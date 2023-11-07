import 'package:concordium_wallet/services/wallet_proxy/model.dart';
import 'package:concordium_wallet/state/network.dart';
import 'package:concordium_wallet/state/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'terms_and_conditions.g.dart';

/// Version of the Terms & Conditions accepted by the user.
class AcceptedTermsAndConditions {
  /// Accepted version.
  final String version;

  const AcceptedTermsAndConditions({required this.version});

  /// Whether the accepted version is valid with respect to the provided valid version.
  bool isValid(TermsAndConditions tac) {
    return version == tac.version;
  }
}

/// Version of the Terms & Conditions that is considered valid.
///
/// The user has to have accepted this version (or more generally, a compatible version)
/// for the acceptance to be valid.
class ValidTermsAndConditions {
  /// T&C configuration fetched from an external endpoint.
  final TermsAndConditions termsAndConditions;

  /// Latest time at which [termsAndConditions] is known to be valid.
  final DateTime refreshedAt;

  const ValidTermsAndConditions({required this.termsAndConditions, required this.refreshedAt});

  /// Constructs an instance for the provided [TermsAndConditions] with a refresh time of the current time.
  factory ValidTermsAndConditions.refreshedNow({required TermsAndConditions termsAndConditions}) {
    return ValidTermsAndConditions(termsAndConditions: termsAndConditions, refreshedAt: DateTime.now());
  }
}

@riverpod
class ActiveNetworkNotifier extends _$ActiveNetworkNotifier {
  @override
  Network? build() => null;

  void select(Network n) {
    state = n;
  }
}

@riverpod
class TermsAndConditionsAcceptedVersionNotifier extends _$TermsAndConditionsAcceptedVersionNotifier {
  @override
  AcceptedTermsAndConditions? build() => null;

  void userAccepted(AcceptedTermsAndConditions tac) {
    state = tac;
  }

  void resetAccepted() {
    state = null;
  }
}

@riverpod
Future<ValidTermsAndConditions?> validTermsAndConditions(ValidTermsAndConditionsRef ref) async {
  final network = ref.watch(activeNetworkNotifierProvider);
  if (network == null) {
    return null;
  }
  final svcs = ref.watch(serviceRepositoryProvider);
  final tac = await svcs.networkServices[network]!.walletProxy.fetchTermsAndConditions();
  return ValidTermsAndConditions.refreshedNow(termsAndConditions: tac);
}
