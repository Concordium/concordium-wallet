import 'dart:convert';
import 'dart:io';

import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';

class WalletProxyConfig {
  final String baseUrl;
  final int port;

  WalletProxyConfig({required this.baseUrl, required this.port});
}

enum WalletProxyEndpoint {
  tacVersion('/v0/termsAndConditionsVersion'),
  ;

  final String path;

  const WalletProxyEndpoint(this.path);
}

class WalletProxyService {
  final WalletProxyConfig config;
  final HttpClient client;

  WalletProxyService({required this.config, required this.client});

  Future<Tac> getTac() async {
    final req = await client.get(config.baseUrl, config.port, WalletProxyEndpoint.tacVersion.path);
    final res = await req.close();
    final str = await res.transform(utf8.decoder).join();
    return Tac.fromJson(json.decode(str));
  }
}
