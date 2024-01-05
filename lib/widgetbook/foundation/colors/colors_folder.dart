import 'package:concordium_wallet/widgetbook/foundation/colors/view_gradients.dart';
import 'package:concordium_wallet/widgetbook/foundation/colors/view_internal_colors.dart';
import 'package:concordium_wallet/widgetbook/foundation/colors/view_semantic_colors.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_folder.dart';

class ColorsFolder extends DefaultFolder {
  ColorsFolder()
      : super(name: 'Colors', children: [
          ViewSemanticColors().component,
          ViewInternalColors().component,
          ViewGradients().component,
        ]);
}
