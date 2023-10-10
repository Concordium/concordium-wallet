import 'package:concordium_wallet/state.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';

import 'package:concordium_wallet/screens/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final prefs = snapshot.data;
        if (prefs == null) {
          // Loading preferences.
          return const CircularProgressIndicator();
        }
        return ChangeNotifierProvider(
          create: (context) => AppState(AppSharedPreferences(prefs)),
          child: MaterialApp(
            routes: appRoutes,
            theme: concordiumTheme(),
          ),
        );
      },
    );
  }
}
