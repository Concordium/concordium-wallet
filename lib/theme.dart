import 'package:flutter/material.dart';

ThemeData concordiumTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 18, height: 1.25),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );
}
