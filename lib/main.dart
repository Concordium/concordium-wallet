import 'package:concordium_wallet/repositories/terms_and_conditions_repository.dart';
import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const App());
}

const testnetNetwork = Network(
  name: NetworkName.testnet,
  walletProxyConfig: WalletProxyConfig(
    baseUrl: 'https://wallet-proxy.testnet.concordium.com',
  ),
);

/// Load fundamental configuration from the source of truth.
Future<Config> loadConfig(HttpService http) async {
  // In the future, this will be loaded from a proper source rather than being hardcoded.
  return Config.ofNetworks([
    testnetNetwork,
  ]);
}

Future<ServiceRepository> bootstrap() async {
  const http = HttpService();
  final configFuture = loadConfig(http);
  final storageFuture = StorageProvider.init();
  final config = await configFuture;
  final storageService = await storageFuture;
  return ServiceRepository(
    config: config,
    http: http,
    storage: storageService,
  );
}

const initialNetwork = NetworkName.testnet;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize configuration and service repository.
    return FutureBuilder<ServiceRepository>(
      future: bootstrap(),
      builder: (_, snapshot) {
        final services = snapshot.data;
        if (services == null) {
          // Initializing configuration and service repository.
          return const _Initializing();
        }
        // Provide initialized service repository to the nested components
        // (including the blocs created in the child provider).
        // Then activate the initial network (starting services related to that network).
        return RepositoryProvider(
          create: (_) => services,
          child: FutureBuilder(
            future: services.activateNetwork(initialNetwork),
            builder: (_, snapshot) {
              final networkServices = snapshot.data;
              if (networkServices == null) {
                // Initializing network services.
                return const _Initializing();
              }

              // Initialize blocs/cubits.
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) {
                      // Initialize selected network as the one that was just activated.
                      return SelectedNetwork(networkServices);
                    },
                  ),
                  BlocProvider(
                    create: (context) {
                      // Initialize T&C by loading the currently accepted version.
                      final storage = context.read<ServiceRepository>().storage;
                      return TermsAndConditionAcceptance(TermsAndConditionsRepository(storageProvider: storage));
                    },
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

class _Initializing extends StatelessWidget {
  const _Initializing();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        // Setting text direction is required because we're outside 'MaterialApp' widget.
        Text('Initializing...', textDirection: TextDirection.ltr),
      ],
    );
  }
}
