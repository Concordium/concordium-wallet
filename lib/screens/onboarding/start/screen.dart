import 'package:concordium_wallet/screens/onboarding/page.dart';
import 'package:concordium_wallet/state/auth.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingStartScreen extends StatefulWidget {
  const OnboardingStartScreen({super.key});

  @override
  State<OnboardingStartScreen> createState() => _OnboardingStartScreenState();
}

class _OnboardingStartScreenState extends State<OnboardingStartScreen> {
  @override
  void initState() {
    super.initState();
    final tacState = context.read<TermsAndConditionAcceptance>().state;
    // Check if onboarding is already complete.
    // For now we only check if *any* T&C version has been accepted
    // as the valid version currently isn't fetched until we enter the "new" screen.
    // (It isn't clear atm what the actual desired T&C refresh behavior is.)
    final auth = context.read<ServiceRepository>().auth;
    if (auth.canAuthenticate() && tacState.accepted != null) {
      // Onboarding is already complete; navigate straight to home screen.
      Future(() => context.go('/home')); // using 'go' instead of 'push' to disallow going back
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
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
