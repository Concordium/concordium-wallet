import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/network.dart';

class NetworkServices {
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

class ServiceRepository {
  final Map<Network, NetworkServices> networkServices;
  final SharedPreferencesService sharedPreferences;

  const ServiceRepository({required this.networkServices, required this.sharedPreferences});
}
