import 'dart:io';

import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_service.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  var walletProxyService = WalletProxyService(
    config: WalletProxyConfig(
      baseUrl: 'wallet-proxy.testnet.concordium.com',
      port: 80,
    ),
    client: HttpClient(),
  );
}
