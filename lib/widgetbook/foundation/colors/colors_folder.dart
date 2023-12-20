import 'package:concordium_wallet/widgetbook/foundation/colors/view_semantic_colors.dart';
import 'package:concordium_wallet/widgetbook/foundation/colors/view_internal_colors.dart';
import 'package:concordium_wallet/widgetbook/foundation/typography/view_typography.dart';
import 'package:concordium_wallet/widgetbook/graphics/icons/view_icons.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_folder.dart';

class ColorsFolder extends DefaultFolder {
  ColorsFolder()
      : super(name: 'Colors', children: [
    ViewSemanticColors().component,
    ViewInternalColors().component,
  ]);
}
