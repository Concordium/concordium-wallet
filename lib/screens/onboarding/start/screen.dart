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
  late final Future<bool> _checking;

  @override
  void initState() {
    super.initState();
    final tacState = context.read<TermsAndConditionAcceptance>().state;
    // Check if onboarding is already complete.
    // For now we only check if *any* T&C version has been accepted
    // as the valid version currently isn't fetched until we enter the "new" screen.
    // (It isn't clear atm what the actual desired T&C refresh behavior is.)
    final auth = context.read<ServiceRepository>().auth;

    _checking = () async {
      final canAuthenticate = await auth.canAuthenticate();
      return canAuthenticate && tacState.accepted != null;
    }();
    // if (canAuthenticate && tacState.accepted != null) {
    //   return
    //     // Onboarding is already complete; navigate straight to home screen.
    //     Future(() => context.go('/home')); // using 'go' instead of 'push' to disallow going back
    // }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      body: FutureBuilder<bool>(
        future: _checking,
        builder: (context, snapshot) {
          final isOnboarded = snapshot.data;
          var disableButtons = true;
          if (isOnboarded != null) {
            if (isOnboarded) {
              // Send onboarded user off to home screen.
              Future.microtask(() => context.go('/home'));
            } else {
              disableButtons = false;
            }
          }
          return Column(
            children: [
              const Expanded(child: Center(child: Text(''))),
              ElevatedButton(
                onPressed: disableButtons ? null : () => context.push('/onboarding/new'),
                child: const Text('Create a new wallet'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: disableButtons ? null : () => context.push('/onboarding/recover'),
                // NOTE: This resets the valid T&C which is picked up by the BlocConsumer's listener above to automatically trigger a re-fetch.
                child: const Text('I already have a wallet'),
              ),
            ],
          );
        },
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
