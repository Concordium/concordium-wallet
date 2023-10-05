import 'dart:convert';
import 'dart:io';

import 'package:concordium_wallet/services/wallet_proxy/wallet_proxy_model.dart';

enum WalletProxyEndpoint {
  tacVersion('/v0/termsAndConditionsVersion'),
  ;

  final String path;

  const WalletProxyEndpoint(this.path);
}

class WalletProxyConfig {
  final String baseUrl;

  WalletProxyConfig({required this.baseUrl});

  Uri urlOf(WalletProxyEndpoint e) {
    // We're not worrying about URL encoding of the path
    // as none of the endpoints have special characters.
    return Uri.parse('$baseUrl/${e.path}');
  }
}

class WalletProxyService {
  final WalletProxyConfig config;
  final HttpClient client;

  WalletProxyService({required this.config, required this.client});

  Future<TermsAndConditions> getTac() async {
    final url = config.urlOf(WalletProxyEndpoint.tacVersion);
    final req = await client.getUrl(url);
    final res = await req.close();
    final str = await res.transform(utf8.decoder).join();
    return TermsAndConditions.fromJson(json.decode(str));
  }
}
