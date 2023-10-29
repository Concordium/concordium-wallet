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
  final Map<Network, NetworkServices> networkServices;

  /// Global service for interacting with shared preferences.
  final SharedPreferencesService sharedPreferences;

  const ServiceRepository({required this.networkServices, required this.sharedPreferences});
}
