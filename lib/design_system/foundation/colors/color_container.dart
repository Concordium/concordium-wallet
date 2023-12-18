import 'package:concordium_wallet/design_system/foundation/colors/color_icon.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_layer.dart';
import 'package:concordium_wallet/design_system/foundation/colors/color_text.dart';

///
class ColorContainer {
  ColorContainer({
    required this.icon,
    required this.text,
    required this.layer,
  });

  final ColorIcon icon;
  final ColorText text;
  final ColorLayer layer;
}
