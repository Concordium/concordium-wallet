import 'package:concordium_wallet/shell/theme.dart';
import 'package:concordium_wallet/shell/app_state.dart';
import 'package:concordium_wallet/shell/routes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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