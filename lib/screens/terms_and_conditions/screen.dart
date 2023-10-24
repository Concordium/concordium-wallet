import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/states/inherited_tac.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final TermsAndConditions currentTac;

  const TermsAndConditionsScreen(this.currentTac, {super.key});

  Future<void> userAccepted(TacState tacState) {
    return tacState.setTermsAndConditionsLastVerifiedAt(DateTime.now(), currentTac.version);
  }

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isAccepted = false;

  void _setAccepted(bool val) {
    setState(() {
      isAccepted = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tacState = context.tacState;

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
                    ),
                  ),
                  Center(
                    child: SvgPicture.asset(
                      'assets/graphics/padlock_shield.svg',
                      semanticsLabel: 'Padlock shield',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Before you begin',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  children: [
                    Text('Before you start using the Concordium Mobile Wallet, you have to set up a passcode and optionally biometrics.'),
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
                      _launchUrl(widget.currentTac.url);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          const TextSpan(text: 'I have read and agree to the '),
                          TextSpan(
                            text: 'Terms and Conditions v${widget.currentTac.version}',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switch (tacState.version) {
                            null => const TextSpan(text: '.'),
                            String v => TextSpan(
                                text: ' (you previously accepted version $v).',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          },
                        ],
                      ),
                    ),
                  ),
                ),
                ToggleAcceptedWidget(
                  isAccepted: isAccepted,
                  setAccepted: _setAccepted,
                ),
              ],
            ),
            const SizedBox(height: 9),
            ElevatedButton(
              onPressed: _onAcceptButtonPressed(tacState),
              child: const Text('Continue'),
            ),
          ],
        ),
      ],
    );
  }

  Function()? _onAcceptButtonPressed(TacState tacState) {
    if (isAccepted) {
      return () async => await widget.userAccepted(tacState);
    }
    return null;
  }

  void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // TODO If this fails, open a dialog with the URL so the user can visit it manually.
      throw 'Could not launch $url';
    }
  }
}
