import 'package:flutter/material.dart';

ThemeData startTheme() {
  final theme = globalTheme();
  return theme.copyWith(
    scaffoldBackgroundColor: const Color.fromRGBO(5, 37, 53, 1),
    progressIndicatorTheme: theme.progressIndicatorTheme.copyWith(color: Colors.white),
    textTheme: theme.textTheme.copyWith(
      bodySmall: theme.textTheme.bodySmall?.copyWith(
        color: Colors.white,
      )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: theme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          double opacity = .5;
          if (states.contains(MaterialState.disabled)) {
            opacity = .1;
          }
          return const Color.fromRGBO(109, 181, 190, 1).withOpacity(opacity);
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          double opacity = 1;
          if (states.contains(MaterialState.disabled)) {
            opacity = .5;
          }
          return Colors.white.withOpacity(opacity);
        }),
      ),
    ),
  );
}

ThemeData globalTheme() {
  const textDisplaySmall = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  const textBodyMedium = TextStyle(fontSize: 18, height: 1.25);
  return ThemeData(
    useMaterial3: true,
    // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(82, 167, 178, 1),
      ),
    ),
  );
}
