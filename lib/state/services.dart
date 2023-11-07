import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Provider for 'ServiceRepository'.
///
/// The implementation is a simple placeholder that just throws an error.
/// It's expected to be overridden in 'ProviderScope' by the result of 'initServiceRepository'; see 'main.dart'.
/// The reason for this setup is to avoid the provider from having to be async just because it's initialization is.
/// Rather, we want to wait for the value to be available on app startup and then use the value without async.
final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  throw UnimplementedError();
});

Future<ServiceRepository> initServiceRepository(Network n, HttpService httpService) async {
  final prefs = await SharedPreferences.getInstance();
  return ServiceRepository(
    networkServices: {n: NetworkServices.forNetwork(n, httpService: httpService)},
    sharedPreferences: SharedPreferencesService(prefs),
  );
}

