import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final Widget? pageHeaderWidget;
  final AppBar? appBar;
  const BasePage({super.key, required this.child, this.pageHeaderWidget, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFF2F2F2), Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0),
        appBar: appBar,
        body: Column(
          children: [
            if (pageHeaderWidget != null) pageHeaderWidget!,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
