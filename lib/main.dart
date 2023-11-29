import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/auth/service.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/auth.dart';
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
  final prefsFuture = SharedPreferences.getInstance();
  final config = await configFuture;
  final prefs = await prefsFuture;
  final sharedPreferences = SharedPreferencesService(prefs);
  return ServiceRepository(
    config: config,
    http: http,
    auth: AuthenticationService(sharedPreferences),
    sharedPreferences: sharedPreferences,
  );
}

const initialNetwork = NetworkName.testnet;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return _WithServiceRepository(
      child: _WithSelectedNetwork(
        initialNetwork: initialNetwork,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                // Initialize T&C by loading the currently accepted version from shared preferences.
                final prefs = context.read<ServiceRepository>().sharedPreferences;
                return TermsAndConditionAcceptance(prefs);
              },
            ),
            BlocProvider.value(value: Authentication()),
          ],
          child: MaterialApp.router(
            routerConfig: appRouter,
            theme: globalTheme(),
          ),
        ),
      ),
    );
  }
}

class _WithServiceRepository extends StatefulWidget {
  final Widget child;

  const _WithServiceRepository({required this.child});

  @override
  State<_WithServiceRepository> createState() => _WithServiceRepositoryState();
}

class _WithServiceRepositoryState extends State<_WithServiceRepository> {
  late final Future<ServiceRepository> _bootstrapping;

  @override
  void initState() {
    super.initState();
    setState(() {
      _bootstrapping = bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceRepository>(
      future: _bootstrapping,
      builder: (_, snapshot) {
        final services = snapshot.data;
        if (services == null) {
          // Initializing configuration and service repository.
          return const _Initializing();
        }
        return RepositoryProvider.value(
          value: services,
          child: widget.child,
        );
      },
    );
  }
}

class _WithSelectedNetwork extends StatefulWidget {
  final NetworkName initialNetwork;
  final Widget child;

  const _WithSelectedNetwork({required this.initialNetwork, required this.child});

  @override
  State<_WithSelectedNetwork> createState() => _WithSelectedNetworkState();
}

class _WithSelectedNetworkState extends State<_WithSelectedNetwork> {
  late final Future<NetworkServices> _activating;

  @override
  void initState() {
    super.initState();
    final services = context.read<ServiceRepository>();
    setState(() {
      _activating = services.activateNetwork(initialNetwork);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _activating,
      builder: (_, snapshot) {
        final networkServices = snapshot.data;
        if (networkServices == null) {
          // Initializing network services.
          return const _Initializing();
        }

        // Initialize blocs/cubits.
        return BlocProvider(
          create: (_) {
            // Initialize selected network as the one that was just activated.
            return SelectedNetwork(networkServices);
          },
          child: widget.child,
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
