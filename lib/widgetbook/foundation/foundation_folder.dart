import 'package:concordium_wallet/widgetbook/foundation/colors/view_colors.dart';
import 'package:concordium_wallet/widgetbook/graphics/icons/view_icons.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_folder.dart';

class FoundationFolder extends DefaultFolder {
  FoundationFolder()
      : super(name: 'Foundation', children: [
          ViewColors().component,
          ViewIcons().component,
        ]);
}
