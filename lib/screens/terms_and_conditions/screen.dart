import 'package:concordium_wallet/screens/terms_and_conditions/widget.dart';
import 'package:concordium_wallet/services/url_launcher.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final TermsAndConditions validTermsAndConditions;
  final String? acceptedTermsAndConditionsVersion;
  final UrlLauncher urlLauncher;

  const TermsAndConditionsScreen(
      {super.key, required this.validTermsAndConditions, this.acceptedTermsAndConditionsVersion, required this.urlLauncher});

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
                  AppLocalizations.of(context).before_you_begin,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context).intro_text),
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
                          TextSpan(text: AppLocalizations.of(context).read_and_agree),
                          TextSpan(
                            text: AppLocalizations.of(context).terms_and_conditions(widget.validTermsAndConditions.version),
                            style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          switch (widget.acceptedTermsAndConditionsVersion) {
                            null => const TextSpan(text: '.'),
                            String v => TextSpan(
                                text: AppLocalizations.of(context).previously_accepted(v),
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
              child: Text(AppLocalizations.of(context).cont),
            ),
          ],
        ),
      ],
    );
  }

  Function()? _onAcceptButtonPressed(BuildContext context) {
    if (isAccepted) {
      return () {
        final tac = AcceptedTermsAndConditions.acceptedNow(widget.validTermsAndConditions.version);
        context.read<TermsAndConditionAcceptance>().userAccepted(tac);
      };
    }
    return null;
  }

  void _launchUrl(Uri url) async {
    if (await widget.urlLauncher.canLaunch(url)) {
      await widget.urlLauncher.launch(url);
    } else {
      // TODO If this fails, open a dialog with the URL so the user can visit it manually.
      throw 'Could not launch $url';
    }
  }
}
