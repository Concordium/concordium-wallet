import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:flutter/material.dart';

/// These are 'primitive' gradients that should never be referenced directly from code.
/// They are only meant to be used internally by the semantic gradient tokens
class InternalGradient {
  static Gradient disable = _buildGradient(colors: const [InternalColor.black20, InternalColor.black10]);

  // TODO(RHA): Is it intentional that the end color is missing?
  static Gradient darkMineral = _buildGradient(colors: const [InternalColor.oceanBlue, Color(0xFF2E8894)]);
  static Gradient lightMode = _buildGradient(colors: const [InternalColor.black05, InternalColor.white]);
  static Gradient lightBlue = _buildGradient(colors: const []);

  static Gradient _buildGradient({required List<Color> colors}) =>
      LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [colors.first, colors.last]);
}
