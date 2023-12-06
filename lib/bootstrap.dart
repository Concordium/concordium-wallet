import 'package:concordium_wallet/providers/storage.dart';
import 'package:concordium_wallet/repositories/terms_and_conditions_repository.dart';
import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:concordium_wallet/state/config.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:concordium_wallet/state/terms_and_conditions.dart';

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

/// Load fundamental configuration from the source of truth.
Future<Config> loadConfig(HttpService http) async {
  // In the future, this will be loaded from a proper source rather than being hardcoded.
  const testnetNetwork = Network(
    name: NetworkName.testnet,
    walletProxyConfig: WalletProxyConfig(
      baseUrl: 'https://wallet-proxy.testnet.concordium.com',
    ),
  );
  return Config.ofNetworks([
    testnetNetwork,
  ]);
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

  final activatingNetwork = services.activateNetwork(initialNetworkName);
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
  final tac = TermsAndConditionsAcceptance(
    tacRepo,
    acceptedTac,
    ValidTermsAndConditions.refreshedNow(termsAndConditions: validTac),
  );
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

