import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class MockHttpService extends Mock implements HttpService {
  String data;

  MockHttpService(this.data);

  @override
  Future<http.Response> get(Uri url) {
    return Future.value(http.Response(data, 200));
  }
}

void main() {
  test("WalletProxyService returns specified version and url", () async {
    // Arrange
    const tacUrl = "http://tac.com";
    const tacVersion = "1.2.3";
    const rawData = '{"url":"$tacUrl","version":"$tacVersion"}';

    var httpClient = MockHttpService(rawData);

    var service = WalletProxyService(
        config: WalletProxyConfig(baseUrl: 'http://test.com'),
        httpService: httpClient);

    // Act
    var tac = await service.getTac();

    // Assert
    expect(tac.url.toString(), tacUrl);
    expect(tac.version, tacVersion);
  });
}
