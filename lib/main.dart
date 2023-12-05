import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/repositories/terms_and_conditions_repository.dart';
import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class BootstrapData {
  final ServiceRepository services;
  final SelectedNetwork selectedNetwork;
  final TermsAndConditionsAcceptance termsAndConditionsAcceptance;

  const BootstrapData({required this.services, required this.selectedNetwork, required this.termsAndConditionsAcceptance});
}

class BootstrapProgress {
  final int progressPercentage;
  final BootstrapData? result;

  const BootstrapProgress({required this.progressPercentage, required this.result});

  factory BootstrapProgress.incomplete({required int progressPercentage}) {
    return BootstrapProgress(progressPercentage: progressPercentage, result: null);
  }

  factory BootstrapProgress.complete({required BootstrapData result}) {
    return BootstrapProgress(progressPercentage: 100, result: result);
  }
}

Future<ServiceRepository> startGlobalServices(HttpService http) async {
  final configFuture = loadConfig(http);
  final storageFuture = StorageProvider.init();
  final config = await configFuture;
  final storageService = await storageFuture;
  return ServiceRepository(config: config, http: http, storage: storageService);
}

Future<SelectedNetwork> startSelectedNetwork(NetworkName initialNetworkName, ServiceRepository services) async {
  final networkServices = await services.activateNetwork(initialNetworkName);
  return SelectedNetwork(networkServices);
}

Future<TermsAndConditionsAcceptance> loadAcceptedTermsAndConditions(StorageProvider storage) async {
  final repo = TermsAndConditionsRepository(storageProvider: storage);
  final tac = await repo.getAcceptedTermsAndConditions();
  return TermsAndConditionsAcceptance(repo, tac);
}

Stream<BootstrapProgress> bootstrap(NetworkName initialNetworkName) async* {
  const http = HttpService();
  yield BootstrapProgress.incomplete(progressPercentage: 0);

  final startingGlobalServices = startGlobalServices(http);
  final startingGlobalServicesDelay = Future.delayed(const Duration(milliseconds: 1500));
  final services = await startingGlobalServices;
  await startingGlobalServicesDelay;
  yield BootstrapProgress.incomplete(progressPercentage: 20);

  final selectingNetwork = startSelectedNetwork(initialNetworkName, services);
  final selectingNetworkDelay = Future.delayed(const Duration(milliseconds: 500));
  final selectedNetwork = await selectingNetwork;
  await selectingNetworkDelay;
  yield BootstrapProgress.incomplete(progressPercentage: 70);

  final loadingAcceptedTac = loadAcceptedTermsAndConditions(services.storage);
  final loadingAcceptedTacDelay = Future.delayed(const Duration(milliseconds: 1000));
  final tac = await loadingAcceptedTac;
  await loadingAcceptedTacDelay;
  yield BootstrapProgress.incomplete(progressPercentage: 100);

  final finalDelay = Future.delayed(const Duration(milliseconds: 1000));
  await finalDelay;

  yield BootstrapProgress.complete(
    result: BootstrapData(
      services: services,
      selectedNetwork: selectedNetwork,
      termsAndConditionsAcceptance: tac,
    ),
  );
}

const initialNetwork = NetworkName.testnet;

void main() {
  runApp(App(bootstrap(initialNetwork)));
}

class App extends StatelessWidget {
  final Stream<BootstrapProgress> _bootstrapping;

  const App(this._bootstrapping, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BootstrapProgress>(
      stream: _bootstrapping,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const _Initializing(progressPercentage: 0);
        }
        final result = data.result;
        if (result == null) {
          return _Initializing(progressPercentage: data.progressPercentage);
        }
        return RepositoryProvider.value(
          value: result.services,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: result.selectedNetwork),
              BlocProvider.value(value: result.termsAndConditionsAcceptance),
            ],
            child: MaterialApp.router(
              routerConfig: appRouter,
              theme: globalTheme(),
            ),
          ),
        );
      },
    );
  }
}

class _Initializing extends StatefulWidget {
  final int progressPercentage;

  const _Initializing({required this.progressPercentage});

  @override
  State<_Initializing> createState() => _InitializingState();
}

class _InitializingState extends State<_Initializing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
  );

  @override
  void didUpdateWidget(covariant _Initializing oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.progressPercentage / 100.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final v = _controller.value;
              // Render as spinner (i.e. indeterminate value) when complete instead of being stuck at full circle.
              return CircularProgressIndicator(value: v > .99 ? null : v);
            },
          ),
          // CircularProgressIndicator(value: widget.progressPercentage / 100.0),
          const SizedBox(height: 16),
          // Setting text direction is required because we're outside 'MaterialApp' widget.
          const Text('Initializing...'),
        ],
      ),
      theme: globalTheme(),
    );
  }
}
