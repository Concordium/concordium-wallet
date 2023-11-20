import 'package:flutter/material.dart';

ThemeData globalTheme() {
  const textDisplaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  const textBodyMedium = TextStyle(fontSize: 18, height: 1.25);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    textTheme: const TextTheme(
      bodySmall: TextStyle(fontSize: 14, height: 1.25),
      bodyMedium: textBodyMedium,
      displaySmall: textDisplaySmall,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, kMinInteractiveDimension),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        textStyle: textBodyMedium,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 1.0,
      ),
    ),
  );
}
