import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch currently valid T&C version unconditionally when initializing the widget.
    final tacAcceptance = context.read<TermsAndConditionAcceptance>();
    final network = context.read<SelectedNetwork>();
    final services = context.read<ServiceRepository>().networkServices[network.selected]!;
    _updateValidTac(services.walletProxy, tacAcceptance);
  }

  static Future<void> _updateValidTac(WalletProxyService walletProxy, TermsAndConditionAcceptance tacAcceptance) async {
    final tac = await walletProxy.getTermsAndConditions();
    tacAcceptance.validVersionUpdated(ValidTermsAndConditions.refreshedNow(termsAndConditions: tac));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Builder(
          builder: (context) {
            final tacState = context.watch<TermsAndConditionAcceptance>();
            final validTac = tacState.valid;
            if (validTac == null) {
              // Show spinner if no valid T&C have been resolved yet (not as a result of actually ongoing fetch).
              // Should store the future from '_updateValidTac' and use that in a wrapping 'FutureBuilder'..?
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Center(child: Text('Waiting for enforced Terms & Conditions...')),
                ],
              );
            }
            final acceptedTac = tacState.accepted;
            if (acceptedTac == null || !acceptedTac.isValid(validTac.termsAndConditions)) {
              return TermsAndConditionsScreen(
                validTermsAndConditions: validTac.termsAndConditions,
                acceptedTermsAndConditionsVersion: acceptedTac?.version,
              );
            }
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
                  onPressed: () => context.read<TermsAndConditionAcceptance>().testResetValidTime(),
                  child: const Text('Reset update time of valid T&C'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().resetValid(),
                  // NOTE: This breaks the app because no re-fetch is triggered - hot restart is necessary to recover.
                  child: const Text('Reset valid T&C (and break the app)'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    const tac = AcceptedTermsAndConditions(version: '1.2.3');
                    context.read<TermsAndConditionAcceptance>().userAccepted(tac);
                  },
                  child: const Text('Set accepted T&C version to 1.2.3'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<TermsAndConditionAcceptance>().resetAccepted(),
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
