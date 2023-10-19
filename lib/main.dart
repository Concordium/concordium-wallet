import 'package:concordium_wallet/states/inherited_shared_prefs.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';

import 'package:concordium_wallet/screens/routes.dart';
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
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return InheritedSharedPreferences(
          prefs: snapshot.data!,
          child: MaterialApp(
            routes: appRoutes,
            theme: concordiumTheme(),
          )
        );
      }
    );
  }
}
