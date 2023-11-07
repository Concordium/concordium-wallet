import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';

final config = Config.ofNetworks([
  const Network(
    name: NetworkName.testnet,
    walletProxyConfig: WalletProxyConfig(
      baseUrl: 'https://wallet-proxy.testnet.concordium.com',
    ),
  ),
]);
