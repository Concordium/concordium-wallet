import 'package:concordium_wallet/bootstrap.dart';
import 'package:concordium_wallet/screens/start/bootstrap.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/graphics/concordium-logo.svg',
                  semanticsLabel: 'Concordium Logo',
                ),
              ),
            ),
            Bootstrapping(initialNetwork: initialNetwork, onContinue: onContinue),
          ],
        ),
      ),
    );
  }
}
