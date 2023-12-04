import 'package:flutter/material.dart';

class BasePage extends StatelessWidget {
  static const backgroundColor = Color.fromRGBO(251, 251, 251, 1);

  final String? title;
  final Widget body;

  const BasePage({super.key, this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: backgroundColor,
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: body,
      ),
      resizeToAvoidBottomInset: false, // avoid bottom things to be pushed above the keyboard when it appears
    );
  }

  AppBar? _appBar() {
    return title == null
        ? null
        : AppBar(
            title: Center(child: Text(title!)),
            // backgroundColor: backgroundColor,
          );
  }
}
