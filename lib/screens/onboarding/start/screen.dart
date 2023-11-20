import 'package:concordium_wallet/screens/onboarding/page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingStartScreen extends StatelessWidget {
  const OnboardingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      title: 'Welcome',
      body: Column(
        children: [
          const Expanded(child: Center(child: Text(''))),
          ElevatedButton(
            onPressed: () => context.push('/onboarding/new'),
            child: const Text('Create a new wallet'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.push('/onboarding/recover'),
            // NOTE: This resets the valid T&C which is picked up by the BlocConsumer's listener above to automatically trigger a re-fetch.
            child: const Text('I already have a wallet'),
          ),
        ],
      ),
    );
  }
}
