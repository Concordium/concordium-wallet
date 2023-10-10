import 'dart:io';

import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final WalletProxyConfig walletProxyConfig;

  Network({required this.walletProxyConfig});
}

final testnet = Network(
  walletProxyConfig: WalletProxyConfig(
    baseUrl: 'https://wallet-proxy.testnet.concordium.com',
  ),
);

class AppState extends ChangeNotifier {
  final network = testnet;
  final walletProxyService = WalletProxyService(
    config: testnet.walletProxyConfig,
    client: HttpClient(),
  );

  var _tacLastCheckedAt = DateTime.fromMicrosecondsSinceEpoch(0); // force recheck when starting app

  DateTime get tacLastCheckedAt => _tacLastCheckedAt;

  void setTacLastCheckedAt(DateTime v) {
    _tacLastCheckedAt = v;
    notifyListeners();
  }

  final SharedPreferences sharedPreferences;

  AppState(this.sharedPreferences);
}
