import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';
import 'package:concordium_wallet/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TacScreen extends StatelessWidget {
  const TacScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
        appBar: AppBar(title: const Text('Terms&Conditions')),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: FutureBuilder<Tac>(
            future: state.walletProxyService.getTac(),
            builder: (context, snapshot) {
              final err = snapshot.error;
              if (err != null) {
                // TODO What to do here?
                return Text('Cannot fetch terms and conditions: $err.');
              }
              final tac = snapshot.data;
              if (tac != null) {
                return TacDataScreen(tac);
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}

class TacDataScreen extends StatelessWidget {
  final Tac tac;

  const TacDataScreen(this.tac, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Before you begin',
            style: Theme.of(context).textTheme.displaySmall),
        const Text(
            'Before you start using the Concordium Mobile Wallet, you have to set up a passcode and optionally biometrics.'),
        const Text(
            'It is very important that you keep your passcode safe, because it is the only way to access your accounts. Concordium is not able to change your passcode or help you unlock your wallet if you lose your passcode.'),
        const Text('I have read and agree to the [terms and conditions].'),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Create password'),
        ),
      ],
    );
  }
}
