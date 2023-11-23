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

/// Load fundamental configuration from the source of truth.
Future<Config> loadConfig(HttpService http) async {
  // In the future, this will be loaded from a proper source rather than being hardcoded.
  return Config.ofNetworks([
    const Network(
      name: NetworkName.testnet,
      walletProxyConfig: WalletProxyConfig(
        baseUrl: 'https://wallet-proxy.testnet.concordium.com',
      ),
    ),
  ]);
}

Future<ServiceRepository> bootstrap() async {
  const http = HttpService();
  final configFuture = loadConfig(http);
  final prefsFuture = SharedPreferences.getInstance();
  final config = await configFuture;
  final prefs = await prefsFuture;
  return ServiceRepository(
    config: config,
    http: http,
    auth: AuthService(prefs),
    sharedPreferences: SharedPreferencesService(prefs),
  );
}

const initialNetwork = NetworkName.testnet;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize configuration and service repository.
    return _WithBootstrap(
      child: _WithInitialNetwork(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                // Initialize T&C by loading the currently accepted version from shared preferences.
                final prefs = context.read<ServiceRepository>().sharedPreferences;
                return TermsAndConditionAcceptance(prefs);
              },
            ),
            BlocProvider(
              create: (context) {
                // Initialize auth.
                final prefs = context.read<ServiceRepository>().sharedPreferences;
                return Auth(prefs);
              },
            ),
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

class _WithBootstrap extends StatefulWidget {
  final Widget child;

  const _WithBootstrap({super.key, required this.child});

  @override
  State<_WithBootstrap> createState() => _WithBootstrapState();
}

class _WithBootstrapState extends State<_WithBootstrap> {
  Future<ServiceRepository>? _bootstrapping;

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
        // print('services = $services');
        if (services == null) {
          // Initializing configuration and service repository.
          return const _Initializing();
        }
        // Provide initialized service repository to the nested components
        // (including the blocs created in the child provider).
        // Then activate the initial network (starting services related to that network).
        return RepositoryProvider(
          create: (_) => services,
          child: widget.child,
        );
      },
    );
  }
}

class _WithInitialNetwork extends StatefulWidget {
  final Widget child;

  const _WithInitialNetwork({super.key, required this.child});

  @override
  State<_WithInitialNetwork> createState() => _WithInitialNetworkState();
}

class _WithInitialNetworkState extends State<_WithInitialNetwork> {
  Future<NetworkServices>? _future;

  @override
  void initState() {
    super.initState();
    final services = context.read<ServiceRepository>();
    setState(() {
      _future = services.activateNetwork(initialNetwork);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (_, snapshot) {
        final networkServices = snapshot.data;
        // print('snapshot = $snapshot');
        if (networkServices == null) {
          // Initializing network services.
          // print('initializing 2');
          return const _Initializing();
        }
        return BlocProvider(
          create: (context) {
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
