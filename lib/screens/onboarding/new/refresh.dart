import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithValidTermsAndConditions extends StatefulWidget {
  final Widget Function(ValidTermsAndConditions) builder;

  const WithValidTermsAndConditions({super.key, required this.builder});

  @override
  State<WithValidTermsAndConditions> createState() => _WithValidTermsAndConditionsState();
}

class _WithValidTermsAndConditionsState extends State<WithValidTermsAndConditions> {

  static Future<void> _updateValidTac(WalletProxyService walletProxy, TermsAndConditionAcceptance tacAcceptance) async {
    final tac = await walletProxy.fetchTermsAndConditions();
    tacAcceptance.validVersionUpdated(ValidTermsAndConditions.refreshedNow(termsAndConditions: tac));
  }

  @override
  void initState() {
    super.initState();
    final network = context.read<SelectedNetwork>().state;
    final tacAcceptance = context.read<TermsAndConditionAcceptance>();
    _updateValidTac(network.services.walletProxy, tacAcceptance);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TermsAndConditionAcceptance, TermsAndConditionsAcceptanceState>(
      builder: (context, tacState) {
        final validTac = tacState.valid;
        if (validTac == null) {
          // Show spinner if no valid T&C have been resolved yet (not as a result of actually ongoing fetch).
          // Should store the future from '_updateValidTac' and use that in a wrapping 'FutureBuilder'..?
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Center(child: Text('Loading Terms & Conditions...')),
            ],
          );
        }

        return widget.builder(validTac);
      },
    );
  }
}
