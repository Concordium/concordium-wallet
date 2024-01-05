import 'package:concordium_wallet/widgetbook/foundation/colors/colors_folder.dart';
import 'package:concordium_wallet/widgetbook/foundation/typography/view_typography.dart';
import 'package:concordium_wallet/widgetbook/graphics/icons/view_icons.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_folder.dart';

class FoundationFolder extends DefaultFolder {
  FoundationFolder()
      : super(name: 'Foundation', children: [
          ColorsFolder(),
          ViewTypography().component,
          ViewIcons().component,
        ]);
}
