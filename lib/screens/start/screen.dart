import 'package:concordium_wallet/bootstrap.dart';
import 'package:concordium_wallet/screens/start/terms_and_conditions.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/widgets/progress.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final NetworkName initialNetwork;
  final Function(BootstrapData) onContinue;

  const StartScreen({super.key, required this.initialNetwork, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Column(
          children: [
            const Expanded(child: Center(child: Text('Concordium Logo'))),
            Bootstrapping(initialNetwork: initialNetwork, onContinue: onContinue),
          ],
        ),
      ),
    );
  }
}

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

  Function()? _onContinuePressed() {
    var tac = widget.termsAndConditionsAcceptance;
    if (tac.state.isAnyAccepted()) {
      // Terms have already been accepted: Button is enabled.
      // TODO: Navigate directly to home screen.
      return widget.onContinue;
    }
    // No terms have been previously accepted: Require acceptance before enabling continue button.
    if (!_tacAccepted) {
      // Switch isn't toggled: Disable button.
      return null;
    }
    // Switch is toggled: Continue will accept terms.
    return () {
      tac.userAccepted(AcceptedTermsAndConditions.acceptedNow(tac.state.valid.termsAndConditions.version));
      widget.onContinue();
    };
  }

  @override
  Widget build(BuildContext context) {
    var acceptedTac = widget.termsAndConditionsAcceptance.state.accepted;
    return Column(
      children: [
        if (acceptedTac == null)
          TermsAndConditionsAcceptanceToggle(
            validTermsAndConditions: widget.termsAndConditionsAcceptance.state.valid,
            isAccepted: _tacAccepted,
            setAccepted: _setTacAccepted,
          ),
        ElevatedButton(onPressed: _onContinuePressed(), child: const Text('Continue')),
      ],
    );
  }
}
