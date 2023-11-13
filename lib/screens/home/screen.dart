import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
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

  Future<void>? _validTacFetch;

  @override
  void initState() {
    super.initState();

    // Fetch currently valid T&C version unconditionally when initializing the widget.
    // TODO: Use the 'tacAcceptance.state.valid.updatedAt' to determine whether to perform the refresh
    //       (now and on other appropriate triggers like activating the app).
    _refresh(context);
  }

  static Future<void> _updateValidTac(WalletProxyService walletProxy, TermsAndConditionAcceptance tacAcceptance) async {
    final tac = await walletProxy.fetchTermsAndConditions();
    tacAcceptance.validVersionUpdated(ValidTermsAndConditions.refreshedNow(termsAndConditions: tac));
  }

  void _refresh(BuildContext context) {
    final network = context.read<ActiveNetwork>().state;
    final services = context.read<ServiceRepository>().networkServices[network.active]!;
    final tacAcceptance = context.read<TermsAndConditionAcceptance>();

    // TODO: Remove test delay.
    const testDelay = Duration(seconds: 2);
    _validTacFetch = Future.delayed(testDelay, () => _updateValidTac(services.walletProxy, tacAcceptance));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: BlocConsumer<TermsAndConditionAcceptance, TermsAndConditionsAcceptanceState>(
          listenWhen: (previous, current) {
            return current.valid == null;
          },
          listener: (context, state) {
            _refresh(context);
          },
          builder: (context, tacState) {
            return FutureBuilder(
              future: _validTacFetch,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // Show spinner while valid T&C is being resolved.
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
                final validTac = tacState.valid;
                var validTermsAndConditions = validTac?.termsAndConditions;
                if (validTermsAndConditions != null && (acceptedTac == null || !acceptedTac.isValid(validTermsAndConditions))) {
                  return TermsAndConditionsScreen(
                    validTermsAndConditions: validTermsAndConditions,
                    acceptedTermsAndConditionsVersion: acceptedTac?.version,
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Accepted T&C version: ${acceptedTac?.version}'),
                          Text('Valid T&C last refreshed at ${validTac?.refreshedAt}.'),
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
                      // NOTE: This resets the valid T&C which is picked up by the BlocConsumer's listener above to automatically trigger a re-fetch.
                      child: const Text('Reset valid T&C'),
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
            );
          },
        ),
      ),
    );
  }
}
