import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';
import 'package:concordium_wallet/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TocScreen extends StatelessWidget {
  const TocScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
        appBar: AppBar(title: const Text('Terms&Conditions')),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: FutureBuilder<Toc>(
            future: state.walletProxyService.getToc(),
            builder: (context, snapshot) {
              print(snapshot);

              return Column(
                children: [
                  Text('Version: ${snapshot.data?.version}'),
                  Text('URL: ${snapshot.data?.url}'),
                ],
              );
            },
          ),
        ));
  }
}
