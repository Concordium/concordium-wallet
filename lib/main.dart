import 'package:concordium_wallet/state.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';

import 'package:concordium_wallet/screens/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        routes: appRoutes,
        theme: concordiumTheme(),
      ),
    );
  }
}
