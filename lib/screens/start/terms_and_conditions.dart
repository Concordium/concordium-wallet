import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/widgets/toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsAcceptanceToggle extends StatelessWidget {
  final ValidTermsAndConditions validTermsAndConditions;
  final bool isAccepted;
  final Function(bool) setAccepted;

  const TermsAndConditionsAcceptanceToggle({
    super.key,
    required this.validTermsAndConditions,
    required this.isAccepted,
    required this.setAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                constraints: BoxConstraints(
                  // Limit sheet to 90% of the screen height.
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                builder: (context) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TermsAndConditionsWebView(
                          url: validTermsAndConditions.termsAndConditions.url,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: const [
                  TextSpan(text: 'I agree with the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Toggle(
          key: const Key('input:accept-tac'),
          isEnabled: isAccepted,
          setEnabled: setAccepted,
        ),
      ],
    );
  }
}

class TermsAndConditionsWebView extends StatefulWidget {
  final Uri url;

  const TermsAndConditionsWebView({super.key, required this.url});

  @override
  State<TermsAndConditionsWebView> createState() => _TermsAndConditionsWebViewState();
}

class _TermsAndConditionsWebViewState extends State<TermsAndConditionsWebView> {
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
