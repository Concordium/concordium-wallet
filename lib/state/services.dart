import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';

/// Collection of all services of a network.
class NetworkServices {
  /// The Wallet Proxy service on the network.
  final WalletProxyService walletProxy;

  const NetworkServices({required this.walletProxy});

  factory NetworkServices.forNetwork(Network n, {required HttpService httpService}) {
    return NetworkServices(
      walletProxy: WalletProxyService(
        config: n.walletProxyConfig,
        httpService: httpService,
      ),
    );
  }
}

/// Collection of all services available to the app.
class ServiceRepository {
  /// Service collections for all "enabled" networks (as defined in [Config.availableNetworks]).
  final Map<Network, NetworkServices> networkServices = const {};

  /// Global configuration used when starting services.
  final Config config;

  /// Global service for performing HTTP calls.
  final HttpService httpService;

  /// Global service for interacting with shared preferences.
  final SharedPreferencesService sharedPreferences;

  const ServiceRepository({required this.config, required this.httpService, required this.sharedPreferences});

  /// Enable the network with the provided name.
  ///
  /// The services for interacting with the network are initialized using the global configuration.
  /// Once the future completes, the services may be looked up by the network name in [networkServices].
  Future<void> enableNetwork(NetworkName name) async {
    final n = config.availableNetworks[name];
    if (n == null) {
      throw Exception('unknown network');
    }
    return _enableNetwork(n);
  }

  void _enableNetwork(Network n) {
    if (networkServices.containsKey(n)) {
      throw Exception('network is already enabled');
    }
    _setNetwork(n, NetworkServices.forNetwork(n, httpService: httpService));
  }

  void _setNetwork(Network n, NetworkServices services) {
    networkServices[n] = services;
  }
}
