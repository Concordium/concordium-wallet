import 'package:concordium_wallet/design_system/components/buttons/button.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_component.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class ViewButton extends DefaultComponent {
  ViewButton() : super(name: 'Button');

  @override
  Widget buildDefault(BuildContext context) => Button(
        text: context.knobs.string(label: 'Text', initialValue: 'Label'),
        theme: context.widgetBookTheme,
      );
}
