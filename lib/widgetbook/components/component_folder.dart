import 'package:concordium_wallet/widgetbook/components/account_summary_card/view_account_summary_card.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_folder.dart';

class ComponentFolder extends DefaultFolder {
  ComponentFolder()
      : super(name: 'Components', children: [
          ViewAccountSummaryCard().component,
        ]);
}
