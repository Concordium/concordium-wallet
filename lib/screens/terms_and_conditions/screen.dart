import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final TermsAndConditions validTermsAndConditions;
  final String? acceptedTermsAndConditionsVersion;

  const TermsAndConditionsScreen({super.key, required this.validTermsAndConditions, this.acceptedTermsAndConditionsVersion});

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
                      _launchUrl(widget.validTermsAndConditions.url);
                    },
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          const TextSpan(text: 'I have read and agree to the '),
                          TextSpan(
                            text: 'Terms and Conditions v${widget.validTermsAndConditions.version}',
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switch (widget.acceptedTermsAndConditionsVersion) {
                            null => const TextSpan(text: '.'),
                            String v => TextSpan(
                                text: ' (you previously accepted v$v).',
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
              onPressed: _onAcceptButtonPressed(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      ],
    );
  }

  Function()? _onAcceptButtonPressed(BuildContext context) {
    if (isAccepted) {
      return () {
        final tac = AcceptedTermsAndConditions.acceptNow(widget.validTermsAndConditions.version);
        context.read<TermsAndConditionAcceptance>().userAccepted(tac);
      };
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
