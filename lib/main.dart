import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';

import 'package:concordium_wallet/screens/routes.dart';

void main() {
  runApp(MaterialApp(
            routes: appRoutes,
            theme: concordiumTheme(),
          ));
}
