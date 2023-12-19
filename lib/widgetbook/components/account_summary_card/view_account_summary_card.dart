import 'package:concordium_wallet/design_system/components/account_summary_card/account_summary_card.dart';
import 'package:concordium_wallet/design_system/components/account_summary_card/card_decorations.dart';
import 'package:concordium_wallet/widgetbook/helpers/ccd_widgetbook_theme.dart';
import 'package:concordium_wallet/widgetbook/helpers/default_component.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

class ViewAccountSummaryCard extends DefaultComponent {
  ViewAccountSummaryCard() : super(name: 'Account Summary Card');

  @override
  Widget buildDefault(BuildContext context) => AccountSummaryCard(
        accounts: 1,
        accountLabel: context.knobs.string(label: 'accounts', initialValue: 'Account'),
        atDisposalLabel: context.knobs.string(label: 'At disposal'),
        atDisposal: context.knobs.double.input(label: 'At disposal', initialValue: 100),
        ccdAmount: context.knobs.double.input(label: 'total amount', initialValue: 200),
        fiatAmount: context.knobs.double.input(label: 'dollar amount', initialValue: 100),
        decoration: context.knobs.list(label: 'gradients', options: [CardDecorations.teal, CardDecorations.orange, CardDecorations.purple]),
        balanceLabel: context.knobs.string(label: 'balanceLabel', initialValue: 'Total Wallet Balance'),
        theme: context.widgetBookTheme,
      );
}
