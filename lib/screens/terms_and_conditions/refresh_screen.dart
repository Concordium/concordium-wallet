import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshTermsAndConditionsScreen extends StatelessWidget {
  const RefreshTermsAndConditionsScreen({super.key});

  void _markCheckPerformed(BuildContext context) {
    // Updating timestamp of checking T&C.
    context.read<AppState>().setTermsAndConditionsLastVerifiedAt(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final acceptedTacVersion = state.sharedPreferences.termsAndConditionsAcceptedVersion;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: FutureBuilder<TermsAndConditions>(
          future: state.walletProxyService.getTac(),
          builder: (context, snapshot) {
            final err = snapshot.error;
            if (err != null) {
              // TODO What to do here?
              return Text('Cannot fetch terms and conditions: $err.');
            }
            final currentTac = snapshot.data;
            // print('currentTac.version=${currentTac?.version}, acceptedTacVersion=$acceptedTacVersion');
            if (currentTac != null) {
              // TODO It feels wrong to have this business logic in the widget builder.
              if (currentTac.version == acceptedTacVersion) {
                // print('already accepted; dismissing');
                // Current T&C is already accepted; update the T&C check time to make the home screen replace this widget.
                Future.microtask(() => _markCheckPerformed(context));
              } else {
                return TermsAndConditionsScreen(
                  TermsAndConditionsViewModel(
                    currentTac,
                    acceptedTacVersion,
                    _markCheckPerformed,
                  ),
                );
              }
            }
            // Loading current T&C version.
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
