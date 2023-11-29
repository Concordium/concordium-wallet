import 'package:concordium_wallet/state/auth.dart';
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
  @override
  void initState() {
    super.initState();
    final auth = context.read<Authentication>();
    if (auth.state.needsAuthentication()) {
      // TODO: Navigate to authentication screen (or do biometrics magic).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: BlocBuilder<TermsAndConditionAcceptance, TermsAndConditionsAcceptanceState>(
          builder: (context, tacState) {
            return BlocBuilder<Authentication, AuthenticationState>(
              builder: (context, authState) {
                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Accepted T&C version: ${tacState.accepted?.version}'),
                          Text('Valid T&C last refreshed at ${tacState.valid?.refreshedAt}.'),
                          Text('Needs authentication: ${authState.needsAuthentication()}'),
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
                      onPressed: () async {
                        final services = context.read<ServiceRepository>();
                        final authentication = context.read<Authentication>();
                        await services.auth.resetPassword();
                        authentication.setAuthenticated(false);

                      },
                      child: const Text('Reset password'),
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
