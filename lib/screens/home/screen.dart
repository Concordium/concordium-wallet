import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    // Fetch currently valid T&C version when initializing the widget.
    // TODO: Use the "last verified" time to determine whether to perform the refresh now and whenever the home screen is loaded.
    final network = context.read<SelectedNetwork>().state;
    final services = context.read<ServiceRepository>().networkServices[network]!;
    final tac = context.read<TermsAndConditionAcceptance>();
    // TODO: Store future in state to be used to indicate that there's an ongoing fetch?
    services.walletProxy.getTermsAndConditions().then(tac.validVersionUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: BlocBuilder<TermsAndConditionAcceptance, TermsAndConditionsAcceptanceState>(
          builder: (context, tacState) {
            final validTac = tacState.valid;
            if (validTac == null) {
              // Show spinner if no valid T&C have been resolved yet (not as a result of actually ongoing fetch).
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Waiting for Terms & Conditions...'),
                  ],
                ),
              );
            }
            final acceptedTac = tacState.accepted;
            if (acceptedTac == null || !acceptedTac.isValid(validTac)) {
              return TermsAndConditionsScreen(
                valid: validTac,
                acceptedVersion: acceptedTac?.version,
              );
            }
            return Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('T&C last verified at ${tacState.accepted?.lastVerifiedAt}.'),
                      Text('Last T&C version accepted: ${tacState.accepted?.version}'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().resetAccepted(),
                  child: const Text('Reset accepted T&C'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().resetValid(),
                  // NOTE: This breaks the app because no re-fetch is triggered - hot restart is necessary to recover.
                  child: const Text('Reset valid T&C (breaks the app!)'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().testSetAcceptedVersion('1.2.3'),
                  child: const Text('Set accepted version to "1.2.3"'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().testResetAcceptedTime(),
                  child: const Text('Reset accepted time'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
