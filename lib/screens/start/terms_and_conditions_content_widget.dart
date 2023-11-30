import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsContentWidget extends StatefulWidget {
  final Uri url;

  const TermsAndConditionsContentWidget({super.key, required this.url});

  @override
  State<TermsAndConditionsContentWidget> createState() => _TermsAndConditionsContentWidgetState();
}

class _TermsAndConditionsContentWidgetState extends State<TermsAndConditionsContentWidget> {
  static final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer()),
  };

  final _tacContentWebViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted) // TODO: should get plain HTML without any JS!
    ..setBackgroundColor(Colors.white);

  @override
  void initState() {
    super.initState();
    _tacContentWebViewController.loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _tacContentWebViewController,
      gestureRecognizers: gestureRecognizers, // enable scrolling
    );
  }
}
