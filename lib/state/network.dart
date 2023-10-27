import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:flutter/foundation.dart';

/// Name of a network.
class NetworkName {
  final String name;

  const NetworkName(this.name);

  /// Standard name of the testnet network.
  static const NetworkName testnet = NetworkName('testnet');
  /// Standard name of the mainnet network.
  static const NetworkName mainnet = NetworkName('mainnet');
}

/// Configuration of all services of a specific network.
class Network {
  /// Name of the network.
  final NetworkName name;
  /// Configuration of the Wallet Proxy service belonging to the network.
  final WalletProxyConfig walletProxyConfig;

  const Network({required this.name, required this.walletProxyConfig});
}

/// State component acting as the source of truth for what network is currently active in the app.
class ActiveNetwork extends ChangeNotifier {
  /// Currently active network.
  ///
  /// The network is guaranteed to be one of the "enabled" networks (as defined in [Config.availableNetworks]).
  Network active;

  ActiveNetwork(this.active);

  void setActive(Network n) {
    active = n;
    notifyListeners();
  }
}
