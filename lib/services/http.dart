import 'package:http/http.dart' as http;

class HttpService {
  const HttpService();

  Future<http.Response> get(Uri url) async {
    // TODO: Implement retry logic.
    return http.get(url);
  }
}
