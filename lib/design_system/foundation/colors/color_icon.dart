import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:flutter/material.dart';

abstract class ColorIcon {
  Color get primary;
}

class ColorIconLight implements ColorIcon {
  @override
  Color get primary => InternalColor.black;
}

class ColorIconDark implements ColorIcon {
  @override
  Color get primary => InternalColor.white;
}
