import 'dart:io';

import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_service.dart';
import 'package:flutter/material.dart';

class Network {
  final WalletProxyConfig walletProxyConfig;

  Network({required this.walletProxyConfig});
}

final testnet = Network(
  walletProxyConfig: WalletProxyConfig(
    baseUrl: 'wallet-proxy.testnet.concordium.com',
    // baseUrl: '10.0.2.2',
    port: 8080,
  ),
);

class AppState extends ChangeNotifier {
  var network = testnet;
  var walletProxyService = WalletProxyService(
    config: testnet.walletProxyConfig,
    client: HttpClient(),
  );
}
