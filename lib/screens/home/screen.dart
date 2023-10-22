import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/state.dart';
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

    // Fetch currently valid T&C version.
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
                child: CircularProgressIndicator(),
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
                  onPressed: () => context.read<TermsAndConditionAcceptance>().resetAcceptedTime(),
                  child: const Text('Reset check time'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().resetAcceptedVersion(),
                  child: const Text('Reset accepted version'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
