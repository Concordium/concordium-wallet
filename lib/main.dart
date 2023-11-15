import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

// In the future, this will be loaded from a proper source rather than being hardcoded.
final config = Config.ofNetworks([
  const Network(
    name: NetworkName.testnet,
    walletProxyConfig: WalletProxyConfig(
      baseUrl: 'https://wallet-proxy.testnet.concordium.com',
    ),
  ),
]);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (_, snapshot) {
        final prefs = snapshot.data;
        if (prefs == null) {
          return const _LoadingSharedPreferences();
        }
        // Initialize services and provide them to the nested components
        // (including the blocs created in the child provider).
        return RepositoryProvider(
          create: (_) {
            final prefsSvc = SharedPreferencesService(prefs);
            const httpService = HttpService();
            // TODO 'enableNetwork' is async so should be initialized in a 'FutureBuilder'.
            //      Currently it actually is sync though, so this change can wait a bit.
            return ServiceRepository(
              config: config,
              httpService: httpService,
              sharedPreferences: prefsSvc,
            )..enableNetwork(NetworkName.testnet);
          },
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => ActiveNetwork(config.availableNetworks[NetworkName.testnet]!),
              ),
              BlocProvider(
                create: (context) {
                  final prefs = context.read<ServiceRepository>().sharedPreferences;
                  return TermsAndConditionAcceptance(prefs);
                },
              ),
            ],
            child: MaterialApp(
              routes: appRoutes,
              theme: concordiumTheme(),
            ),
          ),
        );
      },
    );
  }
}

class _LoadingSharedPreferences extends StatelessWidget {
  const _LoadingSharedPreferences();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        // Setting text direction is required because we're outside 'MaterialApp' widget.
        Text('Loading shared preferences...', textDirection: TextDirection.ltr),
      ],
    );
  }
}
