import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class SelectedNetworkState {
  /// Services corresponding to the currently selected network (as defined in [Config.availableNetworks]).
  ///
  /// The network is guaranteed to be one of the entries in [ServiceRepository.activeNetworks].
  final NetworkServices services;

  const SelectedNetworkState(this.services);
}

/// State component acting as the source of truth for what network is currently selected in the app.
class SelectedNetwork extends Cubit<SelectedNetworkState> {
  SelectedNetwork(NetworkServices services) : super(SelectedNetworkState(services));

  void select(NetworkServices networkServices) {
    emit(SelectedNetworkState(networkServices));
  }
}
