import 'package:concordium_wallet/screens/onboarding/page.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/widgets/toggle_accepted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingNewScreen extends StatefulWidget {
  const OnboardingNewScreen({super.key});

  @override
  State<OnboardingNewScreen> createState() => _OnboardingNewScreenState();
}

class _OnboardingNewScreenState extends State<OnboardingNewScreen> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  var _isEnableBiometricsChecked = false;
  bool? _doPasswordsMatch;
  
  var _isTermsAndConditionsAccepted = false;

  @override
  void initState() {
    super.initState();
    _refreshValidTermsAndConditions(context);
  }

  static Future<void> _updateValidTac(WalletProxyService walletProxy, TermsAndConditionAcceptance tacAcceptance) async {
    final tac = await walletProxy.fetchTermsAndConditions();
    tacAcceptance.validVersionUpdated(ValidTermsAndConditions.refreshedNow(termsAndConditions: tac));
  }

  void _refreshValidTermsAndConditions(BuildContext context) {
    final network = context.read<SelectedNetwork>().state;
    final tacAcceptance = context.read<TermsAndConditionAcceptance>();
    _updateValidTac(network.services.walletProxy, tacAcceptance);
  }

  void _setEnableBiometricsChecked(bool val) {
    // TODO: Add error that biometrics aren't yet supported...
    setState(() {
      _isEnableBiometricsChecked = val;
    });
  }
  void _setTermsAndConditionsAccepted(bool val) {
    // TODO: Should just persist immediately
    setState(() {
      _isTermsAndConditionsAccepted = val;
    });
  }

  // TODO: Should return (i.e. disable it) if passwords don't match or T&C aren't accepted.
  _onContinuePressed(BuildContext context) {
    // TODO: Check T&C acceptance.
    // TODO: Persist T&C acceptance (if that hasn't happened already).
    // TODO: Check that passwords match.
    // TODO: Persist password (if that hasn't happened already).
    // TODO: Navigate to home screen.
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      title: 'Security',
      body: BlocConsumer<TermsAndConditionAcceptance, TermsAndConditionsAcceptanceState>(
        listenWhen: (previous, current) {
          return current.valid == null;
        },
        listener: (context, state) {
          _refreshValidTermsAndConditions(context);
        },
        builder: (context, tacState) {
          final validTac = tacState.valid;
          if (validTac == null) {
            // Show spinner if no valid T&C have been resolved yet (not as a result of actually ongoing fetch).
            // Should store the future from '_updateValidTac' and use that in a wrapping 'FutureBuilder'..?
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Center(child: Text('Waiting for enforced Terms & Conditions...')),
              ],
            );
          }
          // TODO: Use 'acceptedTac' to pre-check T&C, skip check, or similar?
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/graphics/fingerprint.svg',
                        semanticsLabel: 'Fingerprint',
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Text(
                      'Security',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    TextField(
                      controller: _passwordController1,
                      decoration: const InputDecoration(hintText: 'Enter Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _passwordController2,
                      decoration: const InputDecoration(hintText: 'Confirm Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/graphics/fingerprint.svg',
                                width: 30,
                                height: 30,
                                color: Colors.blueGrey,
                                semanticsLabel: 'Fingerprint',
                              ),
                              const Text('Enable biometric authentication'),
                            ],
                          ),
                        ),
                        Toggle(
                          isEnabled: _isEnableBiometricsChecked,
                          setEnabled: _setEnableBiometricsChecked,
                        ),
                      ],
                    )
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
                            _launchUrl(validTac.termsAndConditions.url);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall,
                              children: const [
                                TextSpan(text: 'I agree with the '),
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Toggle(
                        isEnabled: _isTermsAndConditionsAccepted,
                        setEnabled: _setTermsAndConditionsAccepted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  ElevatedButton(
                    onPressed: _onContinuePressed(context),
                    child: const Text('Continue →'), // TODO: Use real graphics for arrow.
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  // TODO: Open in modal instead.
  void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // TODO: If this fails, open a dialog with the URL so the user can visit it manually.
      throw 'Could not launch $url';
    }
  }
}
