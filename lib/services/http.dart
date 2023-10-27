import 'package:http/http.dart' as http;

/// Service for performing HTTP requests.
///
/// The service is intended to take care of retry logic, cookie management, etc.
class HttpService {
  const HttpService();

  /// Performs an HTTP request asynchronously.
  Future<http.Response> get(Uri url) async {
    return http.get(url);
  }
}
