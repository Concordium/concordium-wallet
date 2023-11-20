import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  static const backgroundColor = Color.fromRGBO(210, 210, 210, 1);

  final String? title;
  final Widget body;

  const OnboardingPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              backgroundColor: backgroundColor,
            ),
      backgroundColor: backgroundColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: body,
      ),
    );
  }
}
