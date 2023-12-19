import 'package:concordium_wallet/design_system/foundation/colors/internal_color.dart';
import 'package:flutter/material.dart';

/// Colors used for icons
///
/// NOTE: Guillermo is currently working on creating semantic color tokens,
/// so for now we have just added a single primary token (with some more or less random colors)
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
