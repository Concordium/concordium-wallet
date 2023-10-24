import 'package:concordium_wallet/states/inherited_shared_prefs.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';

import 'package:concordium_wallet/screens/routes.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppHiveBox>(
        future: AppHiveBox.init(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return InheritedHiveBox(
              appPrefs: snapshot.data!,
              child: MaterialApp(
                routes: appRoutes,
                theme: concordiumTheme(),
              ));
        });
  }
}
