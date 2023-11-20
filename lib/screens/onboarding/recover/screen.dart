import 'package:concordium_wallet/screens/onboarding/page.dart';
import 'package:flutter/material.dart';

class OnboardingRecoverScreen extends StatelessWidget {
  const OnboardingRecoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      title: 'Recover',
      body: Column(
        children: [
          Center(
            child: Text(
              'Recover your wallet',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}
