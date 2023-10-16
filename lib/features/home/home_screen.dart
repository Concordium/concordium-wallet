import 'package:concordium_wallet/features/terms_and_conditions/refresh_screen.dart';
import 'package:concordium_wallet/shell/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tacLastCheckedAt = context.select((AppState state) => state.termsAndConditionsLastVerifiedAt);
    print('tacLastCheckedAt: $tacLastCheckedAt');

    // Temporary...
    final state = context.watch<AppState>();
    var lastAcceptedVersion = state.sharedPreferences.termsAndConditionsAcceptedVersion;
    // print('lastAcceptedVersion: $lastAcceptedVersion');

    // Force recheck after 1 min.
    print('diff: ${DateTime.now().difference(tacLastCheckedAt).inMinutes}');
    if (DateTime.now().difference(tacLastCheckedAt).inMinutes > 1) {
      return const RefreshTermsAndConditionsScreen();
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('T&C last checked at $tacLastCheckedAt.'),
                  Text('Last T&C version accepted: $lastAcceptedVersion'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                state.setTermsAndConditionsLastVerifiedAt(DateTime.fromMillisecondsSinceEpoch(0));
              },
              child: const Text('Reset check time'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                state.sharedPreferences.setTermsAndConditionsAcceptedVersion('0');
              },
              child: const Text('Reset accepted version'),
            ),
          ],
        ),
      ),
    );
  }
}
