import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  final Widget child;
  final Widget? pageHeaderWidget;
  final AppBar? appBar;
  const BasePage({super.key, required this.child, this.pageHeaderWidget, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 3),
          gradient: const LinearGradient(colors: [Colors.yellow, Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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

class BasePageWithPosition extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  const BasePageWithPosition({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.purple, width: 3),
          gradient: const LinearGradient(colors: [Colors.yellow, Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      padding: const EdgeInsets.all(8),
      child: Scaffold(
        backgroundColor: Colors.transparent.withOpacity(0),
        appBar: appBar,
        body: child,
      ),
    );
  }
}

class BasePageCustomAppBar extends StatelessWidget {
  final Widget child;
  final Widget? appBar;
  const BasePageCustomAppBar({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 3),
            gradient: const LinearGradient(colors: [Colors.yellow, Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        padding: const EdgeInsets.all(8),
        child: Column(children: [if (appBar != null) appBar!, child]),
      ),
    );
  }
}
