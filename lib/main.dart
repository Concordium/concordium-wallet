import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/shared_preferences/service.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

final config = Config.ofNetworks([
  const Network(
    name: NetworkName.testnet,
    walletProxyConfig: WalletProxyConfig(
      baseUrl: 'https://wallet-proxy.testnet.concordium.com',
    ),
  ),
]);
const httpService = HttpService();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        final prefs = snapshot.data;
        if (prefs == null) {
          // Loading preferences.
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              // Setting text direction is required because we're outside 'MaterialApp' widget.
              Text('Loading shared preferences...', textDirection: TextDirection.ltr),
            ],
          );
        }
        // Initialize services and provide them to the nested components
        // (including the state components created in the child provider).
        return Provider(
          create: (context) {
            final testnet = config.availableNetworks[NetworkName.testnet]!;
            final prefsSvc = SharedPreferencesService(prefs);
            return ServiceRepository(
              networkServices: {testnet: NetworkServices.forNetwork(testnet, httpService: httpService)},
              sharedPreferences: prefsSvc,
            );
          },
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => SelectedNetwork(config.availableNetworks[NetworkName.testnet]!),
              ),
              ChangeNotifierProvider(
                create: (context) {
                  final prefs = context.read<ServiceRepository>().sharedPreferences;
                  return TermsAndConditionAcceptance(prefs);
                },
              ),
            ],
            child: MaterialApp(
              routes: appRoutes,
              theme: concordiumTheme(),
            ),
          ),
        );
      },
    );
  }
}
