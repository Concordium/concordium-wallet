import 'package:concordium_wallet/screens/terms_and_conditions/terms_and_conditions_screen.dart';
import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';
import 'package:concordium_wallet/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tacLastCheckedAt = context.select((AppState state) => state.tacLastCheckedAt);
    print('tacLastCheckedAt: $tacLastCheckedAt');

    // Temporary...
    final state = context.watch<AppState>();
    var lastAcceptedVersion =
        state.sharedPreferences.getString('tac:accepted_version');
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
            Text('T&C last checked at $tacLastCheckedAt.'),
            Text('Last T&C version accepted: $lastAcceptedVersion'),
            ElevatedButton(
              onPressed: () {
                state.setTacLastCheckedAt(
                    DateTime.fromMillisecondsSinceEpoch(0));
              },
              child: const Text('Reset check time'),
            ),
            ElevatedButton(
              onPressed: () {
                state.sharedPreferences.setString("tac:accepted_version", "0");
              },
              child: const Text('Reset accepted version'),
            ),
          ],
        ),
      ),
    );
  }
}

class RefreshTermsAndConditionsScreen extends StatelessWidget {
  const RefreshTermsAndConditionsScreen({super.key});

  void _markTacCheckPerformed(BuildContext context) {
    // Updating timestamp of checking T&C.
    context.read<AppState>().setTacLastCheckedAt(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final acceptedTacVersion =
        state.sharedPreferences.getString("tac:accepted_version");

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
              if (currentTac.version == acceptedTacVersion) {
                print('already accepted; dismissing');
                // Current T&C is already accepted; update the T&C check time to make the home screen replace this widget.
                // TODO Is this the right way to do that call?
                Future.microtask(() => _markTacCheckPerformed(context));
              } else {
                return TermsAndConditionsContent(TermsAndConditionsViewModel(
                    currentTac, _markTacCheckPerformed));
              }
            }
            // Loading current T&C version.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
