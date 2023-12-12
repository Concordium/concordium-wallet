import 'package:flutter/material.dart';

class CcdColor {
  // Can't actually find any references to internal colors...
  //final _internalColor = InternalColor();

  Color negative(ColorState state) => switch (state) {
        ColorState.dark => const Color(0xFFAB2B2B),
        ColorState.base => const Color(0xFFDC5050),
        ColorState.light => const Color(0xFFE87E90)
      };
}

enum ColorState { dark, base, light }
