import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:flutter/material.dart';

/// Colors used for layers
///
/// Figma link: https://www.figma.com/file/AXkkkw8sIWE9IUfA5upaeN/New-Concordium-Design-System?type=design&node-id=91-99&mode=design&t=H8THDBVPTPjmWcYB-0
abstract class ColorLayer {
  Color get layer01;
}

class ColorLayerLight extends ColorLayer {
  @override
  Color get layer01 => InternalColor.black05;

}

class ColorLayerDark extends ColorLayer {
  @override
  Color get layer01 => InternalColor.black50;

}