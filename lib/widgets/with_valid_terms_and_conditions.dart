import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithValidTermsAndConditions extends StatefulWidget {
  final Duration maxAge;
  final Widget Function(ValidTermsAndConditions) builder;

  const WithValidTermsAndConditions({super.key, this.maxAge = const Duration(minutes: 10), required this.builder});

  @override
  State<WithValidTermsAndConditions> createState() => _WithValidTermsAndConditionsState();
}

class _WithValidTermsAndConditionsState extends State<WithValidTermsAndConditions> {
  late final Future<ValidTermsAndConditions> _updating;

  static Future<ValidTermsAndConditions> _updateValidTac(WalletProxyService walletProxy, TermsAndConditionAcceptance tacAcceptance) async {
    final tac = await walletProxy.fetchTermsAndConditions();
    final result = ValidTermsAndConditions.refreshedNow(termsAndConditions: tac);
    tacAcceptance.validVersionUpdated(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
    final network = context.read<SelectedNetwork>().state;
    final tacAcceptance = context.read<TermsAndConditionAcceptance>();

    // Reload if there's no existing value or if it's older than 'maxAge'.
    final validTac = tacAcceptance.state.valid;
    if (validTac == null || validTac.refreshedAt.isBefore(DateTime.now().subtract(widget.maxAge))) {
      _updating = _updateValidTac(network.services.walletProxy, tacAcceptance);
    } else {
      _updating = Future.value(validTac);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ValidTermsAndConditions>(
      future: _updating,
      builder: (context, snapshot) {
        final validTac = snapshot.data;
        if (validTac == null) {
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
