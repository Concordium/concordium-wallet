import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';

/// Collection of all services related to a specific network.
class NetworkServices {
  /// Network to which the services are related.
  final Network network;

  /// Wallet Proxy service on the network.
  final WalletProxyService walletProxy;

  const NetworkServices({required this.network, required this.walletProxy});

  factory NetworkServices.forNetwork(Network n, {required HttpService http}) {
    return NetworkServices(
      network: n,
      walletProxy: WalletProxyService(
        config: n.walletProxyConfig,
        http: http,
      ),
    );
  }
}

/// Collection of all services available to the app.
class ServiceRepository {
  /// Service collections for all "active" networks (as defined in [Config.availableNetworks]).
  final Map<NetworkName, NetworkServices> activeNetworks = {};

  /// Global configuration used when starting services.
  final Config config;

  /// Global service for performing HTTP calls.
  final HttpService http;

  /// Global service for interacting with shared preferences.
  final SharedPreferencesService sharedPreferences;

  ServiceRepository({required this.config, required this.http, required this.sharedPreferences});

  /// Activate the network with the provided name.
  ///
  /// The services for interacting with the network are initialized using the global configuration.
  /// Once the future completes, the services may be looked up by the network name in [activeNetworks].
  Future<NetworkServices> activateNetwork(NetworkName name) async {
    if (activeNetworks.containsKey(name)) {
      throw Exception('network is already active');
    }
    final n = config.availableNetworks[name];
    if (n == null) {
      throw Exception('unknown network');
    }
    final res = NetworkServices.forNetwork(n, http: http);
    activeNetworks[name] = res;
    return res;
  }
}
