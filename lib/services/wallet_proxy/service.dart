import 'dart:convert';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';

enum WalletProxyEndpoint {
  tacVersion('v0/termsAndConditionsVersion'),
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
  final HttpService httpService;

  WalletProxyService({required this.config, required this.httpService});

  /// Retrieves the terms and conditions from the wallet-proxy.
  Future<TermsAndConditions> getTac() async {
    final url = config.urlOf(WalletProxyEndpoint.tacVersion);
    final response = await httpService.get(url);
    final jsonResponse = jsonDecode(response.body);
    return TermsAndConditions.fromJson(jsonResponse);
  }
}
