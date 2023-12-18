import 'package:flutter/widgets.dart';

/// These are so-called 'primitive' colors that should never be referenced directly from code.
/// They are only meant to be used internally by the semantic color tokens found in the [ColorContainer]
///
/// Figma link to primitive colors: https://www.figma.com/file/AXkkkw8sIWE9IUfA5upaeN/New-Concordium-Design-System?type=design&node-id=91-99&mode=design&t=EdY3Ujqsj1ZSu63r-0
class InternalColor {
  //region Primary
  static const mineralBlue = Color(0xFF48A2AE);
  static const mineral80 = Color(0xFF6DB5BE);
  //endregion

  //region Secondary
  static const darkBlue = Color(0xFF052535);
  //endregion

  //region Neutral
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const black50 = Color(0xFF7F7F7F);
  static const black05 = Color(0xFFF2F2F2);
  //endregion
}
