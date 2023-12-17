import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:flutter/material.dart';

abstract class ColorText {
  Color get primary;
}

class ColorTextDark implements ColorText {
  @override
  Color get primary => InternalColor.white;
}

class ColorTextLight implements ColorText {
  @override
  Color get primary => InternalColor.black;
}
