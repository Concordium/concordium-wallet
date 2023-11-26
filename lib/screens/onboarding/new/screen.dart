import 'package:concordium_wallet/screens/onboarding/page.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/auth.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/widgets/toggle_accepted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingNewScreen extends StatefulWidget {
  const OnboardingNewScreen({super.key});

  @override
  State<OnboardingNewScreen> createState() => _OnboardingNewScreenState();
}

class _OnboardingNewScreenState extends State<OnboardingNewScreen> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  var _password1 = '';
  var _password2 = '';

  var _isEnableBiometricsChecked = false;

  var _isTermsAndConditionsAccepted = false;

  @override
  void initState() {
    super.initState();
    _refreshValidTermsAndConditions(context);

    _passwordController1.addListener(() {
      setState(() {
        _password1 = _passwordController1.value.text;
      });
    });
    _passwordController2.addListener(() {
      setState(() {
        _password2 = _passwordController2.value.text;
      });
    });
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

  void _setTermsAndConditionsAccepted(bool val) {
    setState(() {
      _isTermsAndConditionsAccepted = val;
    });
  }

  static bool isValidPassword(String p) {
    // Will likely add some requirements to length/strength.
    return p.isNotEmpty;
  }

  static String? passwordIfValidAndConfirmed(String password1, String password2) {
    return isValidPassword(password1) && password1 == password2 ? password1 : null;
  }

  Function()? _onContinuePressed(BuildContext context, ValidTermsAndConditions validTac) {
    // Disable button if T&C is not accepted.
    if (!_isTermsAndConditionsAccepted) {
      return null; // disable button
    }
    // Disable button if passwords don't match.
    var password = passwordIfValidAndConfirmed(_password1, _password2);
    if (password == null) {
      return null; // disable button
    }
    // Enable button with the following click handler.
    return () {
      // Persist password.
      final auth = context.read<Auth>();
      auth.setPassword(password);
      // TODO: Persist biometrics stuff.

      // Persist T&C acceptance.
      final tac = context.read<TermsAndConditionAcceptance>();
      tac.userAccepted(AcceptedTermsAndConditions(version: validTac.termsAndConditions.version));

      // Navigate to home screen.
      context.push('/home');
    };
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
                Center(child: Text('Loading Terms & Conditions...')),
              ],
            );
          }
          // TODO: Use 'acceptedTac' to pre-check T&C, skip check, or similar?
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned.fill(
                          child: Container(color: const Color.fromRGBO(235, 236, 238, 1)),
                        ),
                        const Center(
                          child: Image(image: AssetImage('assets/graphics/fingerprint.png')),
                        )
                      ],
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
                                'assets/graphics/face_id.svg',
                                semanticsLabel: 'Fingerprint',
                              ),
                              const SizedBox(width: 6),
                              const Text('Enable biometric authentication'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          child: Toggle(
                            isEnabled: _isEnableBiometricsChecked,
                            setEnabled: null, // disable toggle
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Biometrics support is not yet implemented.'),
                            ));
                          },
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
                      Expanded(
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
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _onContinuePressed(context, validTac),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Continue'),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/graphics/arrow_forward.svg',
                        ),
                      ],
                    ), // TODO: Use real graphics for arrow.
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

  @override
  void dispose() {
    // Clean up the controllers once the widget is removed from the tree.
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }
}
