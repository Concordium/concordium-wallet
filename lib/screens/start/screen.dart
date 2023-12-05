import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        // TODO: Move back to initState?
        child: Column(
          children: [
            const Expanded(child: Center(child: Text('Concordium Logo'))),
            BlocBuilder<TermsAndConditionsAcceptance, TermsAndConditionsAcceptanceState>(
              builder: (context, state) {
                final acceptedTac = state.accepted;
                if (acceptedTac != null) {
                  // Go straight to home screen if ANY T&C version has been previously accepted.
                  // We're not forcing the user to accept even if the version differs from the one that's currently enforced.
                  // If re-acceptance is required, then that should be done from the landing page (or individual features that require it).
                  Future.microtask(() => context.go('/'));
                  return const _Initializing();
                }
                return Column(
                  children: [
                    // TODO: Put T&C thing...
                    ElevatedButton(
                      onPressed: () => context.go('/'),
                      // NOTE: This resets the valid T&C which is picked up by the BlocConsumer's listener above to automatically trigger a re-fetch.
                      child: const Text('I already have a wallet'),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _Initializing extends StatelessWidget {
  const _Initializing();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Initializing...'),
      ],
    );
  }
}
