import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/theme.dart';
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
        // Initialize services and provide them to the nested components
        // (including the blocs created in the child provider).
        return RepositoryProvider(
          create: (context) {
            final testnet = networks[NetworkName.testnet]!;
            final httpSvc = HttpService();
            final prefsSvc = SharedPreferencesService(prefs);
            return ServiceRepository(
              networkServices: {testnet: NetworkServices.forNetwork(testnet, httpService: httpSvc)},
              sharedPreferences: prefsSvc,
            );
          },
          child: Builder(
            builder: (context) {
              // Wrap provider in Builder for services to be available in the context.
              final prefs = context.select(((ServiceRepository s) => s.sharedPreferences));
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SelectedNetwork(networks[NetworkName.testnet]!),
                  ),
                  BlocProvider(
                    create: (context) => TermsAndConditionAcceptance(prefs),
                  ),
                ],
                child: MaterialApp(
                  routes: appRoutes,
                  theme: concordiumTheme(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
