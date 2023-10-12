import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
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

class AppSharedPreferences { // TODO: Extend ChangeNotifier?
  static const _tacAcceptedVersionKey = 'tac:accepted_version';

  final SharedPreferences _prefs;

  AppSharedPreferences(this._prefs);

  get termsAndConditionsAcceptedVersion => _prefs.getString(_tacAcceptedVersionKey);

  void setTermsAndConditionsAcceptedVersion(String v) {
    _prefs.setString(_tacAcceptedVersionKey, v);
  }
}

class AppState extends ChangeNotifier {
  final network = testnet;
  final walletProxyService = WalletProxyService(
    config: testnet.walletProxyConfig,
    httpService: HttpService(),
  );

  var _termsAndConditionsLastVerifiedAt = DateTime.fromMicrosecondsSinceEpoch(0); // force recheck when starting app

  /// The most recent time it was ensured that the currently valid T&C has been accepted.
  DateTime get termsAndConditionsLastVerifiedAt => _termsAndConditionsLastVerifiedAt;

  void setTermsAndConditionsLastVerifiedAt(DateTime v) {
    _termsAndConditionsLastVerifiedAt = v;
    notifyListeners();
  }

  final AppSharedPreferences sharedPreferences;

  AppState(this.sharedPreferences);
}
