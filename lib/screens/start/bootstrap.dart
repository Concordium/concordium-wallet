import 'package:concordium_wallet/bootstrap.dart';
import 'package:concordium_wallet/screens/start/terms_and_conditions.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Bootstrapping extends StatefulWidget {
  final NetworkName initialNetwork;
  final Function(BootstrapData) onContinue;

  const Bootstrapping({super.key, required this.initialNetwork, required this.onContinue});

  @override
  State<Bootstrapping> createState() => _BootstrappingState();
}

class _BootstrappingState extends State<Bootstrapping> {
  late final Stream<BootstrapProgress> _bootstrapping;

  @override
  void initState() {
    super.initState();
    setState(() {
      _bootstrapping = bootstrap(widget.initialNetwork);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BootstrapProgress>(
      stream: _bootstrapping,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          // Bootstrapping didn't start yet.
          return const ProgressSpinner(progressPercentage: 0);
        }
        final result = data.result;
        if (result == null) {
          // Bootstrapping didn't complete yet.
          return ProgressSpinner(progressPercentage: data.progressPercentage);
        }
        // Bootstrapping completed.
        // Check if any version of T&C have been already accepted.
        if (result.termsAndConditionsAcceptance.state.isAnyAccepted()) {
          // Invoke continuation to navigate to the home screen.
          SchedulerBinding.instance.addPostFrameCallback((_) => widget.onContinue(result));
          return const ProgressSpinner(progressPercentage: 100);
        }
        // Bootstrapping completed.
        return BootstrapCompletion(
          termsAndConditionsAcceptance: result.termsAndConditionsAcceptance,
          onContinue: () => widget.onContinue(result),
        );
      },
    );
  }
}

class BootstrapCompletion extends StatefulWidget {
  final TermsAndConditionsAcceptance termsAndConditionsAcceptance;
  final Function() onContinue;

  const BootstrapCompletion({
    super.key,
    required this.termsAndConditionsAcceptance,
    required this.onContinue,
  });

  @override
  State<BootstrapCompletion> createState() => _BootstrapCompletionState();
}

class _BootstrapCompletionState extends State<BootstrapCompletion> {
  var _tacAccepted = false;

  void _setTacAccepted(bool v) {
    setState(() {
      _tacAccepted = v;
    });
  }

  Function()? _createOnContinuePressed() {
    // No terms have been previously accepted (as we ):
    // Require acceptance before enabling continue button.
    if (!_tacAccepted) {
      // Switch isn't toggled: Disable button.
      return null;
    }
    // Switch is toggled: Continue will accept terms.
    return () {
      final tac = widget.termsAndConditionsAcceptance;
      tac.userAccepted(AcceptedTermsAndConditions.acceptedNow(tac.state.valid.termsAndConditions.version));
      widget.onContinue();
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TermsAndConditionsAcceptanceToggle(
          validTermsAndConditions: widget.termsAndConditionsAcceptance.state.valid,
          isAccepted: _tacAccepted,
          setAccepted: _setTacAccepted,
        ),
        ElevatedButton(onPressed: _createOnContinuePressed(), child: const Text('Continue')),
      ],
    );
  }
}
