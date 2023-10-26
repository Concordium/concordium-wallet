import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:flutter/foundation.dart';

class NetworkName {
  final String name;

  const NetworkName(this.name);

  static const NetworkName testnet = NetworkName('testnet');
  static const NetworkName mainnet = NetworkName('mainnet');
}

class Network {
  final NetworkName name;
  final WalletProxyConfig walletProxyConfig;

  const Network({required this.name, required this.walletProxyConfig});
}

class SelectedNetwork extends ChangeNotifier {
  Network selected;

  SelectedNetwork(this.selected);

  void setSelected(Network n) {
    selected = n;
    notifyListeners();
  }
}
