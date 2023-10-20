import 'package:concordium_wallet/screens/home/screen.dart';
import 'package:concordium_wallet/states/inherited_tac.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';

import 'package:concordium_wallet/screens/routes.dart';

void main() {
  runApp(MaterialApp(
      restorationScopeId: 'root',
      routes: appRoutes,
      theme: concordiumTheme(),
    ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> with RestorationMixin {
  @override
  String? get restorationId => "App";
  final tacState = RestorableTacState();

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tacState, "tacState");
  }

  @override
  Widget build(BuildContext context) {
      return InheritedTac(tacState: tacState.value, child: const HomeScreen());
  }
}
