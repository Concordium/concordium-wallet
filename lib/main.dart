import 'package:concordium_wallet/bootstrap.dart';
import 'package:concordium_wallet/designsystem/theme/ThemeState.dart';
import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/screens/start/screen.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'designsystem/theme/AppTheme.dart';

// TODO: We can probably defer network activation until we hit the landing page.
const _initialNetwork = NetworkName.testnet;

void main() {
  runApp(const App(initialNetwork: _initialNetwork));
}

class App extends StatefulWidget {
  final NetworkName initialNetwork;

  const App({super.key, required this.initialNetwork});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  BootstrapData? _data;

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      return MaterialApp(
        home: StartScreen(
          initialNetwork: _initialNetwork,
          onContinue: (data) {
            setState(() {
              _data = data;
            });
          },
        ),
        theme: startTheme(),
      );
    }
    // App is ready and T&C has been accepted. Load landing page...
    return RepositoryProvider.value(
      value: data.services,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: data.selectedNetwork),
          BlocProvider.value(value: data.termsAndConditionsAcceptance),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          theme: globalTheme(),
        ),
      ),
    );
  }
}
