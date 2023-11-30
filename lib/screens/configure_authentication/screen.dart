import 'package:concordium_wallet/screens/page.dart';
import 'package:concordium_wallet/state/auth.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/widgets/toggle_accepted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthenticationData {
  final String password;
  final bool enableBiometrics;

  const AuthenticationData({required this.password, required this.enableBiometrics});
}

class ConfigureAuthenticationScreen extends StatelessWidget {
  const ConfigureAuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Security',
      body: ConfigureAuthenticationForm(
        onContinuePressed: (data) async {
          final services = context.read<ServiceRepository>();
          final authentication = context.read<Authentication>();

          // Persist password and then register the user as authenticated.
          final isPasswordPersisted = await services.auth.setPassword(data.password);
          if (!isPasswordPersisted) {
            throw Exception('cannot persist provided password');
          }
          authentication.setAuthenticated(true);

          // TODO: Enable biometrics if requested.

          // Navigate back to home screen (mount check necessary because of the "await barrier").
          if (!context.mounted) return;
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ConfigureAuthenticationForm extends StatefulWidget {
  final void Function(AuthenticationData data) onContinuePressed;

  const ConfigureAuthenticationForm({super.key, required this.onContinuePressed});

  @override
  State<ConfigureAuthenticationForm> createState() => _ConfigureAuthenticationFormState();
}

class _ConfigureAuthenticationFormState extends State<ConfigureAuthenticationForm> {
  final _passwordController1 = TextEditingController();
  final _passwordController2 = TextEditingController();

  var _password1 = '';
  var _password2 = '';

  var _isEnableBiometricsChecked = false;

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

  static bool isValidPassword(String p) {
    // Will likely add some requirements to length/strength.
    return p.isNotEmpty;
  }

  static String? passwordIfValidAndConfirmed(String password1, String password2) {
    return isValidPassword(password1) && password1 == password2 ? password1 : null;
  }

  Function()? _onContinuePressed(BuildContext context) {
    // Disable button if passwords don't match.
    final password = passwordIfValidAndConfirmed(_password1, _password2);
    if (password == null) {
      return null; // disable button
    }
    return () {
      widget.onContinuePressed(
        AuthenticationData(
          password: password,
          enableBiometrics: _isEnableBiometricsChecked,
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
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Column(
          children: [
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
