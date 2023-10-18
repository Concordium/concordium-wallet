import 'package:concordium_wallet/screens/terms_and_conditions/screen.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:flutter/material.dart';


class RefreshTermsAndConditionsScreen extends StatelessWidget {
  final walletProxyService = WalletProxyService(
    config: WalletProxyConfig.testnet,
    httpService: HttpService(),
  );
  
  RefreshTermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: FutureBuilder<TermsAndConditions>(
          future: walletProxyService.getTac(),
          builder: (context, snapshot) {
            final err = snapshot.error;
            if (err != null) {
              // TODO What to do here?
              return Text('Cannot fetch terms and conditions: $err.');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator()
              );
            }
            return TermsAndConditionsScreen(
                snapshot.data!
              );
          },
        ),
      ),
    );
  }
}
