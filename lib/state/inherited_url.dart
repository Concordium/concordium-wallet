import 'package:concordium_wallet/services/url_launcher.dart';
import 'package:flutter/widgets.dart';

class InheritedUrl extends InheritedWidget {
  final UrlLauncher urlLauncher;
  
  const InheritedUrl({
    super.key,
    required this.urlLauncher,
    required super.child
  });

  static InheritedUrl of(BuildContext context) {
    final i = context.dependOnInheritedWidgetOfExactType<InheritedUrl>();
    assert(i != null);
    return i!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
