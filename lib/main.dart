import 'package:concordium_wallet/config.dart';
import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const httpService = HttpService();

// From 'https://codewithandrea.com/articles/flutter-state-management-riverpod/#dependency-overrides-with-riverpod'.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final testnet = config.availableNetworks[NetworkName.testnet]!;
  final svcs = await initServiceRepository(testnet, httpService);
  runApp(ProviderScope(
    overrides: [
      // Override placeholder provider with the initialized value.
      // This prevents the provider from having to be async.
      serviceRepositoryProvider.overrideWithValue(svcs),
    ],
    child: MaterialApp(
      routes: appRoutes,
      theme: concordiumTheme(),
    ),
  ));
}
