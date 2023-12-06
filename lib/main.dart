import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/repositories/terms_and_conditions_repository.dart';
import 'package:concordium_wallet/screens/routes.dart';
import 'package:concordium_wallet/screens/start/terms_and_conditions_content_widget.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';
import 'package:concordium_wallet/theme.dart';
import 'package:concordium_wallet/widgets/toggle_accepted.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const testnetNetwork = Network(
  name: NetworkName.testnet,
  walletProxyConfig: WalletProxyConfig(
    baseUrl: 'https://wallet-proxy.testnet.concordium.com',
  ),
);

/// Load fundamental configuration from the source of truth.
Future<Config> loadConfig(HttpService http) async {
  // In the future, this will be loaded from a proper source rather than being hardcoded.
  return Config.ofNetworks([
    testnetNetwork,
  ]);
}

class BootstrapData {
  final ServiceRepository services;
  final SelectedNetwork selectedNetwork;
  final TermsAndConditionsAcceptance termsAndConditionsAcceptance;

  const BootstrapData({
    required this.services,
    required this.selectedNetwork,
    required this.termsAndConditionsAcceptance,
  });
}

class BootstrapProgress {
  final int progressPercentage;
  final BootstrapData? result;

  const BootstrapProgress({required this.progressPercentage, required this.result});

  factory BootstrapProgress.incomplete({required int progressPercentage}) {
    return BootstrapProgress(progressPercentage: progressPercentage, result: null);
  }

  factory BootstrapProgress.complete({required BootstrapData result}) {
    return BootstrapProgress(progressPercentage: 100, result: result);
  }
}

Future<ServiceRepository> startGlobalServices(HttpService http) async {
  final configFuture = loadConfig(http);
  final storageFuture = StorageProvider.init();
  final config = await configFuture;
  final storageService = await storageFuture;
  return ServiceRepository(config: config, http: http, storage: storageService);
}

Future<NetworkServices> startSelectedNetwork(NetworkName initialNetworkName, ServiceRepository services) async {
  return services.activateNetwork(initialNetworkName);
}

Stream<BootstrapProgress> bootstrap(NetworkName initialNetworkName) async* {
  const http = HttpService();
  yield BootstrapProgress.incomplete(progressPercentage: 0);

  final startingGlobalServices = startGlobalServices(http);
  await Future.delayed(const Duration(milliseconds: 1500)); // add concurrent delay to allow the user see that something's happening
  final services = await startingGlobalServices;
  yield BootstrapProgress.incomplete(progressPercentage: 20);

  final activatingNetwork = services.activateNetwork(initialNetwork);
  await Future.delayed(const Duration(milliseconds: 500)); // concurrent delay
  final activatedNetworkServices = await activatingNetwork;
  yield BootstrapProgress.incomplete(progressPercentage: 70);

  // Loading valid T&C. This is necessary if the user hasn't previously accepted.
  // Note that if this was loaded via some global config instead of Wallet Proxy there would be no need for activating a network yet.
  final fetchingValidTac = activatedNetworkServices.walletProxy.fetchTermsAndConditions();
  final tacRepo = TermsAndConditionsRepository(storageProvider: services.storage);
  final loadingAcceptedTac = tacRepo.getAcceptedTermsAndConditions();
  await Future.delayed(const Duration(milliseconds: 1000)); // concurrent delay
  final validTac = await fetchingValidTac;
  final acceptedTac = await loadingAcceptedTac;
  final tac = TermsAndConditionsAcceptance(tacRepo, acceptedTac, ValidTermsAndConditions.refreshedNow(termsAndConditions: validTac),);
  yield BootstrapProgress.incomplete(progressPercentage: 100);

  await Future.delayed(const Duration(milliseconds: 500)); // delay
  yield BootstrapProgress.complete(
    result: BootstrapData(
      services: services,
      selectedNetwork: SelectedNetwork(activatedNetworkServices),
      termsAndConditionsAcceptance: tac,
    ),
  );
}

// TODO: We can probably defer network activation until we hit the landing page.
const initialNetwork = NetworkName.testnet;

void main() {
  runApp(const App(initialNetwork: initialNetwork));
}

class App extends StatefulWidget {
  final NetworkName initialNetwork;

  const App({super.key, required this.initialNetwork});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  BootstrapData? _data;

  @override
  Widget build(BuildContext context) {
    final data = _data;
    if (data == null) {
      print('data is null');
      return MaterialApp(
        home: StartScreen(
          onContinue: (data) {
            setState(() {
              _data = data;
            });
          },
        ),
        theme: globalTheme(),
      );
    }
    print('data is not null');
    // App is ready and T&C has been accepted. Load landing page...
    return RepositoryProvider.value(
      value: data.services,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: data.selectedNetwork),
          BlocProvider.value(value: data.termsAndConditionsAcceptance),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          theme: globalTheme(),
        ),
      ),
    );
  }
}

class StartScreen extends StatelessWidget {
  final Function(BootstrapData) onContinue;

  const StartScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
        child: Column(
          children: [
            const Expanded(child: Center(child: Text('Concordium Logo'))),
            Bootstrapping(initialNetwork: initialNetwork, onContinue: onContinue),
          ],
        ),
      ),
    );
  }
}

class Bootstrapping extends StatefulWidget {
  final NetworkName initialNetwork;
  final Function(BootstrapData) onContinue;

  const Bootstrapping({super.key, required this.initialNetwork, required this.onContinue});

  @override
  State<Bootstrapping> createState() => _BootstrappingState();
}

class _BootstrappingState extends State<Bootstrapping> {
  late final Stream<BootstrapProgress> _bootstrapping;

  @override
  void initState() {
    super.initState();
    setState(() {
      _bootstrapping = bootstrap(widget.initialNetwork);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BootstrapProgress>(
      stream: _bootstrapping,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          // Bootstrapping didn't start yet.
          return const _Initializing(progressPercentage: 0);
        }
        final result = data.result;
        if (result == null) {
          // Bootstrapping didn't complete yet.
          return _Initializing(progressPercentage: data.progressPercentage);
        }
        // Bootstrapping completed.
        return BootstrapCompletion(
          termsAndConditionsAcceptance: result.termsAndConditionsAcceptance,
          onContinue: () => widget.onContinue(result),
        );
      },
    );
  }
}

class BootstrapCompletion extends StatefulWidget {
  final TermsAndConditionsAcceptance termsAndConditionsAcceptance;
  final Function() onContinue;

  const BootstrapCompletion({
    super.key,
    required this.termsAndConditionsAcceptance,
    required this.onContinue,
  });

  @override
  State<BootstrapCompletion> createState() => _BootstrapCompletionState();
}

class _BootstrapCompletionState extends State<BootstrapCompletion> {
  var _tacAccepted = false;

  void _setTacAccepted(bool v) {
    setState(() {
      _tacAccepted = v;
    });
  }

  Function()? _onContinuePressed() {
    var tac = widget.termsAndConditionsAcceptance;
    if (tac.state.isAnyAccepted()) {
      // Terms have already been accepted: Button is enabled.
      return widget.onContinue;
    }
    // No terms have been previously accepted: Require acceptance before enabling continue button.
    if (!_tacAccepted) {
      // Switch isn't toggled: Disable button.
      return null;
    }
    // Switch is toggled: Continue will accept terms.
    return () {
      tac.userAccepted(AcceptedTermsAndConditions.acceptedNow(tac.state.valid.termsAndConditions.version));
      widget.onContinue();
    };
  }

  @override
  Widget build(BuildContext context) {
    var acceptedTac = widget.termsAndConditionsAcceptance.state.accepted;
    return Column(
      children: [
        if (acceptedTac == null)
          TermsAndConditionsAcceptanceToggle(
            validTermsAndConditions: widget.termsAndConditionsAcceptance.state.valid,
            isAccepted: _tacAccepted,
            setAccepted: _setTacAccepted,
          ),
        ElevatedButton(onPressed: _onContinuePressed(), child: const Text('Continue')),
      ],
    );
  }
}

class TermsAndConditionsAcceptanceToggle extends StatelessWidget {
  final ValidTermsAndConditions validTermsAndConditions;
  final bool isAccepted;
  final Function(bool) setAccepted;

  const TermsAndConditionsAcceptanceToggle({
    super.key,
    required this.validTermsAndConditions,
    required this.isAccepted,
    required this.setAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery
                      .of(context)
                      .size
                      .height * 0.9,
                ),
                builder: (context) =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          Expanded(
                            child: TermsAndConditionsContentWidget(
                              url: validTermsAndConditions.termsAndConditions.url,
                            ),
                          ),
                        ],
                      ),
                    ),
              );
            },
            child: RichText(
              text: TextSpan(
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall,
                children: const [
                  TextSpan(text: 'I agree with the '),
                  TextSpan(
                    text: 'Terms and Conditions',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Toggle(
          key: const Key('input:accept-tac'),
          isEnabled: isAccepted,
          setEnabled: setAccepted,
        ),
      ],
    );
  }
}

class _Initializing extends StatefulWidget {
  final int progressPercentage;

  const _Initializing({required this.progressPercentage});

  @override
  State<_Initializing> createState() => _InitializingState();
}

class _InitializingState extends State<_Initializing> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didUpdateWidget(covariant _Initializing oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(
      widget.progressPercentage / 100.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final v = _controller.value;
              // Render as spinner (i.e. indeterminate value) when complete instead of being stuck at full circle.
              return CircularProgressIndicator(value: v > .99 ? null : v);
            },
          ),
          const SizedBox(height: 16),
          const Text('Initializing...'),
        ],
      ),
    );
  }
}
