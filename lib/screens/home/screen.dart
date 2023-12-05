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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: BlocBuilder<TermsAndConditionsAcceptance, TermsAndConditionsAcceptanceState>(
          builder: (context, tacState) {
            return Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Accepted T&C version: ${tacState.accepted?.version}'),
                      Text('Valid T&C last refreshed at ${tacState.valid?.refreshedAt}.'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionsAcceptance>().testResetValidTime(),
                  child: const Text('Reset update time of valid T&C'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionsAcceptance>().resetValid(),
                  // NOTE: This resets the valid T&C which is picked up by the BlocConsumer's listener above to automatically trigger a re-fetch.
                  child: const Text('Reset valid T&C'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final tac = AcceptedTermsAndConditions.acceptedNow('1.2.3');
                    context.read<TermsAndConditionsAcceptance>().userAccepted(tac);
                  },
                  child: const Text('Set accepted T&C version to 1.2.3'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionsAcceptance>().resetAccepted(),
                  child: const Text('Reset accepted T&C'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
