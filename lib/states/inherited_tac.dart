import 'package:concordium_wallet/states/inherited_shared_prefs.dart';
import 'package:flutter/material.dart';

class InheritedTac extends InheritedWidget {
  final TacState tacState;

  const InheritedTac({
    super.key,
    required this.tacState,
    required super.child
  });

  static InheritedTac of(BuildContext context) {
    final i = context.dependOnInheritedWidgetOfExactType<InheritedTac>();
    assert(i != null, "No 'InheritedTac' found above in the tree");
    return i!;
  }
  
  @override
  bool updateShouldNotify(covariant InheritedTac oldWidget) {
    return tacState.refreshTac != tacState.refreshTac;
  }
}

extension BuildContextExt on BuildContext {
  TacState get tacState => InheritedTac.of(this).tacState;
}

class TacState extends ChangeNotifier {
  DateTime? _termsAndConditionsLastVerifiedAt;
  String? _termsAndConditionsAcceptedVersion;
  bool refreshTac;
  final AppSharedPreferences sharedPreferences;

  TacState({
      required this.sharedPreferences,
      required this.refreshTac,
      required String? termsAndConditionsAcceptedVersion,
      required DateTime? termsAndConditionsLastVerifiedAt,
    }) :
    _termsAndConditionsAcceptedVersion = termsAndConditionsAcceptedVersion,
    _termsAndConditionsLastVerifiedAt = termsAndConditionsLastVerifiedAt;

  factory TacState.instance(AppSharedPreferences sharedPreferences) {
    final version = sharedPreferences.termsAndConditionsAcceptedVersion;
    final latest = sharedPreferences.termsAndConditionsLastAccepted;
    final shouldRefresh = (latest == null || version == null || DateTime.now().difference(latest!).inMinutes > 2);

    return TacState(
      sharedPreferences: sharedPreferences,
      refreshTac: shouldRefresh,
      termsAndConditionsAcceptedVersion: version,
      termsAndConditionsLastVerifiedAt: latest
    );
  }

  DateTime? get tacLastVerifiedAt => _termsAndConditionsLastVerifiedAt;
  String? get version => _termsAndConditionsAcceptedVersion;

  Future<void> setTermsAndConditionsLastVerifiedAt(DateTime verified, String version) {
    return _setTermsAndConditionsLastVerifiedAt(verified, version);
  }

  Future<void> resetCheckTime() {
    return _setTermsAndConditionsLastVerifiedAt(null, _termsAndConditionsAcceptedVersion);
  }

  Future<void> resetVersion() {
    return _setTermsAndConditionsLastVerifiedAt(_termsAndConditionsLastVerifiedAt, null);
  }

  Future<void> _setTermsAndConditionsLastVerifiedAt(DateTime? verified, String? version) async {
    refreshTac = _shouldRefreshTacAfterUpdate(verified, version);

    await sharedPreferences.update(verified, version);

    _termsAndConditionsLastVerifiedAt = verified;
    _termsAndConditionsAcceptedVersion = version;

    notifyListeners();
  }

  bool _shouldRefreshTacAfterUpdate(DateTime? newVerified, String? newVersion) {
    return newVerified == null ||
      newVersion == null ||
      (_termsAndConditionsLastVerifiedAt != null && DateTime.now().difference(_termsAndConditionsLastVerifiedAt!).inMinutes > 2) ||
      (_termsAndConditionsAcceptedVersion != null && _termsAndConditionsAcceptedVersion != newVersion);
  }

  void printDiff() {
    if (_termsAndConditionsLastVerifiedAt != null) {
      print('diff: ${DateTime.now().difference(_termsAndConditionsLastVerifiedAt!).inMinutes}');
    }
  }
}
