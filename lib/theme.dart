import 'package:flutter/material.dart';

ThemeData concordiumTheme() {
  const textDisplaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  const textBodyMedium = TextStyle(fontSize: 18, height: 1.25);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    textTheme: const TextTheme(
      bodyMedium: textBodyMedium,
      displaySmall: textDisplaySmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, kMinInteractiveDimension),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: textBodyMedium,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
