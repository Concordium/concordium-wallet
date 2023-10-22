import 'package:concordium_wallet/services/http.dart';
import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/services/wallet_proxy/service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Split/move file.

class Network {
  final NetworkName name;
  final WalletProxyConfig walletProxyConfig;

  Network({required this.name, required this.walletProxyConfig});
}

class NetworkName {
  final String name;

  NetworkName(this.name);

  static NetworkName testnet = NetworkName('testnet');
  static NetworkName mainnet = NetworkName('mainnet');
}

final _testnet = Network(
  name: NetworkName.testnet,
  walletProxyConfig: WalletProxyConfig(
    baseUrl: 'https://wallet-proxy.testnet.concordium.com',
  ),
);

/// All available networks in the app.
final networks = {
  _testnet.name: _testnet,
};

class SharedPreferencesService {
  static const _tacAcceptedVersionKey = 'tac:accepted_version';

  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  String? get termsAndConditionsAcceptedVersion => _prefs.getString(_tacAcceptedVersionKey);

  void setTermsAndConditionsAcceptedVersion(String v) {
    _prefs.setString(_tacAcceptedVersionKey, v);
  }
}

class ServiceRepository {
  final Map<Network, NetworkServices> networkServices;
  final SharedPreferencesService sharedPreferences;

  ServiceRepository({required this.networkServices, required this.sharedPreferences});

// List<Network> get availableNetworks => List.of(networkServices.keys);
}

class NetworkServices {
  final WalletProxyService walletProxy;

  NetworkServices({required this.walletProxy});

  factory NetworkServices.forNetwork(Network n, {required HttpService httpService}) {
    return NetworkServices(
      walletProxy: WalletProxyService(
        config: n.walletProxyConfig,
        httpService: httpService,
      ),
    );
  }
}

// TODO: Should be nullable?
class SelectedNetwork extends Cubit<Network> {
  SelectedNetwork(super.initialState);

  void setNetwork(Network n) {
    emit(n);
  }

  @override
  void onChange(Change<Network> change) {
    super.onChange(change);
    // TODO: Trigger update on with accounts to display, etc.
  }
}

class AcceptedTermsAndConditions {
  final String version;
  final DateTime? lastVerifiedAt; // TODO: looks like this field should be the time of fetching the current valid version

  AcceptedTermsAndConditions({required this.version, required this.lastVerifiedAt});

  AcceptedTermsAndConditions copyWith({String? version, DateTime? lastVerifiedAt}) {
    return AcceptedTermsAndConditions(
      version: version ?? this.version,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
    );
  }

  bool isValid(TermsAndConditions tac) {
    return version == tac.version;
  }
}

class TermsAndConditionsAcceptanceState {
  final AcceptedTermsAndConditions? accepted;
  final TermsAndConditions? valid;

  TermsAndConditionsAcceptanceState({required this.accepted, required this.valid});

  TermsAndConditionsAcceptanceState copyWith({AcceptedTermsAndConditions? accepted, TermsAndConditions? valid}) {
    return TermsAndConditionsAcceptanceState(
      accepted: accepted ?? this.accepted,
      valid: valid ?? this.valid,
    );
  }
}

class TermsAndConditionAcceptance extends Cubit<TermsAndConditionsAcceptanceState> {
  static final _zeroTime = DateTime.fromMicrosecondsSinceEpoch(0);

  final SharedPreferencesService _preferences;

  TermsAndConditionAcceptance(this._preferences) : super(TermsAndConditionsAcceptanceState(accepted: null, valid: null)) {
    final acceptedVersion = _preferences.termsAndConditionsAcceptedVersion;
    if (acceptedVersion != null) {
      userAccepted(AcceptedTermsAndConditions(version: acceptedVersion, lastVerifiedAt: _zeroTime));
    }
  }

  void userAccepted(AcceptedTermsAndConditions tac) {
    emit(state.copyWith(accepted: tac));
  }

  void validVersionUpdated(TermsAndConditions tac) {
    emit(state.copyWith(valid: tac));
  }

  void resetAcceptedVersion() {
    emit(state.copyWith(accepted: state.accepted?.copyWith(version: '')));
  }

  void resetAcceptedTime() {
    emit(state.copyWith(accepted: state.accepted?.copyWith(lastVerifiedAt: _zeroTime)));
  }

  @override
  void onChange(Change<TermsAndConditionsAcceptanceState> change) {
    super.onChange(change);
    // Persist accepted version if it changed.
    final acceptedVersion = change.nextState.accepted?.version;
    if (acceptedVersion != null && acceptedVersion != change.currentState.accepted?.version) {
      _preferences.setTermsAndConditionsAcceptedVersion(acceptedVersion);
    }
  }
}
