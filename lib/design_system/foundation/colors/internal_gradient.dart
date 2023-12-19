import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:flutter/material.dart';

/// These are 'primitive' gradients that should never be referenced directly from code.
/// They are only meant to be used internally by the semantic gradient tokens
class InternalGradient {
  static const disable = LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xFFCCCCCC), Color(0xFFE5E5E5)]);
}