import 'package:concordium_wallet/screens/terms_and_conditions/toggle_widget.dart';
import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';
import 'package:concordium_wallet/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsViewModel {
  final TermsAndConditions currentTac;
  final void Function(BuildContext context) onAccept;

  const TermsAndConditionsViewModel(this.currentTac, this.onAccept);

  void userAccepted(BuildContext context) {
    final state = context.read<AppState>();
    state.sharedPreferences.setString("tac:accepted_version", currentTac.version);
    onAccept(context);
  }
}

class TermsAndConditionsContent extends StatefulWidget {
  final TermsAndConditionsViewModel viewModel;

  const TermsAndConditionsContent(this.viewModel, {super.key});

  @override
  State<TermsAndConditionsContent> createState() =>
      _TermsAndConditionsContentState();
}

class _TermsAndConditionsContentState extends State<TermsAndConditionsContent> {
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
                  )
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
                      _launchUrl(widget.viewModel.currentTac.url);
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
                ToggleAcceptedWidget(
                  isAccepted: isAccepted,
                  setAccepted: _setAccepted,
                ),
              ],
            ),
            const SizedBox(height: 9),
            ElevatedButton(
              onPressed: _onAcceptButtonPressed(context),
              child: const Text('Create password'),
            ),
          ],
        ),
      ],
    );
  }

  Function()? _onAcceptButtonPressed(BuildContext context) {
    if (isAccepted) {
      return () => widget.viewModel.userAccepted(context);
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
