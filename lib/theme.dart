import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData concordiumTheme() {
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
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: textBodyMedium,
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
    ),
  );
}

// TODO use fonts as part of theme

final bodyL = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w400,
  fontSize: 16,
);

final bodyS = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w400,
  fontSize: 12,
);

final heading2 = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w500,
  fontSize: 24,
);

final heading5 = GoogleFonts.getFont(
  "IBM Plex Sans",
  fontWeight: FontWeight.w500,
  fontSize: 16,
);
