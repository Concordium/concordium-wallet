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
                return Column(
                  children: [
                    Text('Version: ${tac.version}'),
                    Text('URL: ${tac.url}'),
                  ],
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ));
  }
}
