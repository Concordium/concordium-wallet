import 'package:flutter/widgets.dart';

/// These are so-called 'primitive' colors that should never be referenced directly from code.
/// They are only meant to be used internally by the semantic color tokens found in the [ColorContainer]
///
/// Figma link to primitive colors: https://www.figma.com/file/AXkkkw8sIWE9IUfA5upaeN/New-Concordium-Design-System?type=design&node-id=91-99&mode=design&t=EdY3Ujqsj1ZSu63r-0
class InternalColor {
  //region Primary
  static const mineralBlue = Color(0xFF48A2AE);
  static const mineral80 = Color(0xFF6DB5BE);
  static const mineral60 = Color(0xFF91C7CE);
  static const mineral40 = Color(0xFFB6DADF);
  static const mineral20 = Color(0xFFDAECEF);
  static const mineral10 = Color(0xFFECF6F7);
  static const mineral05 = Color(0xFFF6FAFB);

  //endregion

  //region Secondary
  static const darkBlue = Color(0xFF052535);
  static const ocean140 = Color(0xFF013243);
  static const ocean120 = Color(0xFF01475F);
  static const oceanBlue = Color(0xFF005A78);
  static const ocean80 = Color(0xFF337B93);
  static const ocean160 = Color(0xFF7FACBB);
  static const eggShellWhite = Color(0xFFFFFDE4);
  static const offWhite = Color(0xFFEBF0F0);

  //endregion

  //region Neutral
  static const black = Color(0xFF000000);
  static const black90 = Color(0xFF191919);
  static const black80 = Color(0xFF333333);
  static const black70 = Color(0xFF4c4c4c);
  static const black60 = Color(0xFF666666);
  static const black50 = Color(0xFF7f7f7f);
  static const black40 = Color(0xFF999999);
  static const black30 = Color(0xFFb2b2b2);
  static const black20 = Color(0xFFcccccc);
  static const black10 = Color(0xFFe5e5e5);
  static const black05 = Color(0xFFf2f2f2);
  static const white = Color(0xFFFFFFFF);

  //endregion

  //region Dark Mode
  static const midnight = Color(0xFF111D2B);
  static const midnightDark = Color(0xFF2D415A);
  static const midnightLight = Color(0xFF5F7897);

  //endregion

  //region State
  static const negativeDark = Color(0xFFab2b2b);
  static const negativeBase = Color(0xFFDC5050);
  static const negativeLight = Color(0xFFE87E90);

  static const positiveDark = Color(0xFF189e46);
  static const positiveBase = Color(0xFF33C364);
  static const positiveLight = Color(0xFF8BE7AA);

  static const warningDark = Color(0xFFc89e0a);
  static const warningBase = Color(0xFFFBCD29);
  static const warningLight = Color(0xFFF6DB9A);

  static const infoDark = Color(0xFF075cab);
  static const infoBase = Color(0xFF2485DF);
  static const infoLight = Color(0xFF65A4DD);

  static const helpDark = Color(0xFF53198e);
  static const helpBase = Color(0xFF7939BA);
  static const helpLight = Color(0xFFB37CDF);
//endregion
}
