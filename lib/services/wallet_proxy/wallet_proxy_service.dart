import 'dart:convert';
import 'dart:io';

import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';

class WalletProxyConfig {
  final String baseUrl;
  final int port;
  final paths = {
    'toc': '/toc',
  };

  WalletProxyConfig({required this.baseUrl, required this.port});
}

class WalletProxyService {
  final WalletProxyConfig config;
  final HttpClient client;

  WalletProxyService({required this.config, required this.client});

  Future<Toc> getToc() async {
    final req = await client.get(config.baseUrl, config.port, '/v0/termsAndConditionsVersion');
    final res = await req.close();
    final str = await res.transform(utf8.decoder).join();
    return Toc.fromJson(json.decode(str));
  }
}
