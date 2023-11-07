import 'package:concordium_wallet/config.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize "active network" provider.
    final activeNetwork = ref.read(activeNetworkNotifierProvider.notifier);
    Future.microtask(() => activeNetwork.select(config.availableNetworks[NetworkName.testnet]!));
  }

  @override
  Widget build(BuildContext context) {
    final validTac = ref.watch(validTermsAndConditionsProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Builder(
          builder: (context) {
            return switch (validTac) {
              AsyncData(:final value) => value == null ? const Text('Nothing to display') : _renderHome(ref, value),
              AsyncError() => const Text('Oops, something unexpected happened'),
              _ => _renderSpinner(),
            };
          },
        ),
      ),
    );
  }
}

Widget _renderSpinner() {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Center(child: Text('Waiting for enforced Terms & Conditions...')),
    ],
  );
}

Widget _renderHome(WidgetRef ref, ValidTermsAndConditions validTac) {
  final acceptedTac = ref.watch(termsAndConditionsAcceptedVersionNotifierProvider);
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
            Text('Accepted T&C version: ${acceptedTac.version}'),
            Text('Valid T&C last refreshed at ${validTac.refreshedAt}.'),
          ],
        ),
      ),
      ElevatedButton(
        onPressed: () => ref.invalidate(validTermsAndConditionsProvider),
        child: const Text('Reset valid T&C'),
      ),
      const SizedBox(height: 8),
      ElevatedButton(
        onPressed: () {
          const tac = AcceptedTermsAndConditions(version: '1.2.3');
          ref.read(termsAndConditionsAcceptedVersionNotifierProvider.notifier).userAccepted(tac);
        },
        child: const Text('Set accepted T&C version to 1.2.3'),
      ),
      const SizedBox(height: 8),
      ElevatedButton(
        onPressed: () => ref.read(termsAndConditionsAcceptedVersionNotifierProvider.notifier).resetAccepted(),
        child: const Text('Reset accepted T&C'),
      ),
    ],
  );
}
