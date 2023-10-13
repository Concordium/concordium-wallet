import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static final UrlLauncher _singleton = UrlLauncher._internal();

  factory UrlLauncher() {
    return _singleton;
  }

  UrlLauncher._internal();

  Future<bool> launch(Uri uri) {
    return launchUrl(uri);
  }

  Future<bool> canLaunch(Uri uri) {
    return canLaunchUrl(uri);
  }
}
