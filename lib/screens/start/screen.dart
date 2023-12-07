import 'package:concordium_wallet/bootstrap.dart';
import 'package:concordium_wallet/screens/start/bootstrap.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  final NetworkName initialNetwork;
  final Function(BootstrapData) onContinue;

  const StartScreen({super.key, required this.initialNetwork, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Column(
          children: [
            const Expanded(child: Center(child: Text('Concordium Logo'))),
            Bootstrapping(initialNetwork: initialNetwork, onContinue: onContinue),
          ],
        ),
      ),
    );
  }
}
