import 'package:concordium_wallet/widgets/with_valid_terms_and_conditions.dart';
import 'package:concordium_wallet/screens/onboarding/new/terms_and_conditions_content_widget.dart';
import 'package:concordium_wallet/screens/onboarding/page.dart';
import 'package:concordium_wallet/state/auth.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/widgets/toggle_accepted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SetupWalletData {
  final String password;
  final bool enableBiometrics;
  final AcceptedTermsAndConditions acceptedTermsAndConditions;

  const SetupWalletData({required this.password, required this.enableBiometrics, required this.acceptedTermsAndConditions});
}

class OnboardingNewWalletScreen extends StatelessWidget {
  const OnboardingNewWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingPage(
      title: 'Security',
      body: WithValidTermsAndConditions(
        builder: (tac) {
          return OnboardingNewWalletForm(
            validTermsAndConditions: tac,
            onContinuePressed: (data) async {
              final services = context.read<ServiceRepository>();
              final authentication = context.read<Authentication>();
              final tac = context.read<TermsAndConditionAcceptance>();

              // Persist password and then register the user as authenticated.
              final isPasswordPersisted = await services.auth.setPassword(data.password);
              if (!isPasswordPersisted) {
                throw Exception('cannot persist provided password');
              }
              authentication.setAuthenticated(true);

              // TODO: Enable biometrics if requested.

              // Persist T&C acceptance.
              tac.userAccepted(data.acceptedTermsAndConditions);

              // Navigate to home screen (mount check necessary because we're awaiting the password set above).
              if (!context.mounted) return;
              context.go('/home'); // using 'go' instead of 'push' to disallow going back
            },
          );
        },
      ),
    );
  }
}

class OnboardingNewWalletForm extends StatefulWidget {
  final ValidTermsAndConditions validTermsAndConditions;
  final void Function(SetupWalletData data) onContinuePressed;

  const OnboardingNewWalletForm({super.key, required this.validTermsAndConditions, required this.onContinuePressed});

  @override
  State<OnboardingNewWalletForm> createState() => _OnboardingNewWalletFormState();
}

class _OnboardingNewWalletFormState extends State<OnboardingNewWalletForm> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  var _password1 = '';
  var _password2 = '';

  var _isEnableBiometricsChecked = false;

  var _isTermsAndConditionsAccepted = false;

  @override
  void initState() {
    super.initState();

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

  Function()? _onContinuePressed(BuildContext context) {
    // Disable button if T&C is not accepted.
    if (!_isTermsAndConditionsAccepted) {
      return null; // disable button
    }
    // Disable button if passwords don't match.
    final password = passwordIfValidAndConfirmed(_password1, _password2);
    if (password == null) {
      return null; // disable button
    }
    return () {
      widget.onContinuePressed(
        SetupWalletData(
          password: password,
          enableBiometrics: _isEnableBiometricsChecked,
          acceptedTermsAndConditions: AcceptedTermsAndConditions(
            version: widget.validTermsAndConditions.termsAndConditions.version,
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
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
                key: const Key('input:password1'),
                controller: _passwordController1,
                decoration: const InputDecoration(hintText: 'Enter Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              TextField(
                key: const Key('input:password2'),
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
                      key: const Key('input:enable-biometrics'),
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Terms and Conditions',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TermsAndConditionsContentWidget(
                                  url: widget.validTermsAndConditions.termsAndConditions.url,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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
                  key: const Key('input:accept-tac'),
                  isEnabled: _isTermsAndConditionsAccepted,
                  setEnabled: _setTermsAndConditionsAccepted,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const Key('button:continue'),
              onPressed: _onContinuePressed(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Continue'),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/graphics/arrow_forward.svg',
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controllers once the widget is removed from the tree.
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }
}
