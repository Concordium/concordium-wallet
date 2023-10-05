import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';
import 'package:concordium_wallet/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
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
          final tac = snapshot.data;
          if (tac != null) {
            return TermsAndConditionsContent(tac);
          }
          return const CircularProgressIndicator();
        },
      ),
    ));
  }
}

class TermsAndConditionsContent extends StatelessWidget {
  final TermsAndConditions data;

  const TermsAndConditionsContent(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Stack(
                children: [
                  Center(
                      child: SvgPicture.asset(
                    'assets/graphics/background_squares.svg',
                    semanticsLabel: 'Background squares',
                  )),
                  Center(
                    child: SvgPicture.asset(
                      'assets/graphics/padlock_shield.svg',
                      semanticsLabel: 'Padlock shield',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                child: Center(
                  child: Text(
                    'Before you begin',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    Text(
                        'Before you start using the Concordium Mobile Wallet, you have to set up a passcode and optionally biometrics.'),
                    SizedBox(height: 9),
                    Text(
                        'It is very important that you keep your passcode safe, because it is the only way to access your accounts. Concordium is not able to change your passcode or help you unlock your wallet if you lose your passcode.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl(data.url);
                    },
                    child: RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: const [
                            TextSpan(text: 'I have read and agree to the '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ]),
                    ),
                  ),
                ),
                Text('<TOGGLE>'),
              ],
            ),
            const SizedBox(height: 9),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Create password'),
            ),
          ],
        ),
      ],
    );
  }

  void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
