import 'dart:convert';

import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';

/// Paths of the wallet-proxy endpoints.
enum WalletProxyEndpoint {
  termsAndConditionsVersion('v0/termsAndConditionsVersion'),
  ;

  final String path;

  const WalletProxyEndpoint(this.path);
}

/// Configuration to control the interaction with a wallet-proxy instance.
class WalletProxyConfig {
  /// Base URL of the instance.
  ///
  /// Endpoint URLs are constructed by simple concatenation of this value and the endpoint path.
  final String baseUrl;

  const WalletProxyConfig({required this.baseUrl});

  Uri urlOf(WalletProxyEndpoint e) {
    // We're not worrying about URL encoding of the path
    // as none of the endpoints have special characters.
    return Uri.parse('$baseUrl/${e.path}');
  }
}

/// Service for interacting with a wallet-proxy instance.
class WalletProxyService {
  /// Configuration of the instance.
  final WalletProxyConfig config;

  /// HTTP service used to send requests to the instance.
  final HttpService httpService;

  const WalletProxyService({required this.config, required this.httpService});

  /// Fetches the currently valid T&C.
  Future<TermsAndConditions> fetchTermsAndConditions() async {
    final url = config.urlOf(WalletProxyEndpoint.termsAndConditionsVersion);
    final response = await httpService.get(url);
    final jsonResponse = jsonDecode(response.body);
    return TermsAndConditions.fromJson(jsonResponse);
  }
}
