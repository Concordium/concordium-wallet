import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Network {
  final NetworkName name;
  final WalletProxyConfig walletProxyConfig;

  const Network({required this.name, required this.walletProxyConfig});
}

class NetworkName {
  final String name;

  const NetworkName(this.name);

  static const NetworkName testnet = NetworkName('testnet');
  static const NetworkName mainnet = NetworkName('mainnet');
}

final _testnet = Network(
  name: NetworkName.testnet,
  walletProxyConfig: WalletProxyConfig(
    baseUrl: 'https://wallet-proxy.testnet.concordium.com',
  ),
);

/// All available networks in the app.
/// TODO: Expose as something nicer than a global const (should be part of the 'SelectedNetwork' cubit)?
final networks = {
  _testnet.name: _testnet,
};

// TODO: Should network be nullable?
class SelectedNetwork extends Cubit<Network> {
  SelectedNetwork(super.initialState);

  void setNetwork(Network n) {
    emit(n);
  }

  @override
  void onChange(Change<Network> change) {
    super.onChange(change);
    // TODO: Trigger update on with accounts to display, etc.
  }
}
