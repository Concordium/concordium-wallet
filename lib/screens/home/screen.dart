import 'package:concordium_wallet/screens/terms_and_conditions/refresh_screen.dart';
import 'package:concordium_wallet/states/inherited_tac.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tacState = context.tacState;

    return ListenableBuilder(
        listenable: tacState,
        builder: (context, _) {
          tacState.printDiff();

          if (tacState.refreshTac) {
            return RefreshTermsAndConditionsScreen();
          }

          return Scaffold(
            body: Container(
              padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                            'T&C last checked at ${tacState.tacLastVerifiedAt}.'),
                        Text('Last T&C version accepted: ${tacState.version}'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      tacState.resetCheckTime();
                    },
                    child: const Text('Reset check time'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      tacState.resetVersion();
                    },
                    child: const Text('Reset accepted version'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
