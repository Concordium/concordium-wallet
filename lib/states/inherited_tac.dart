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
  bool refreshTac = true;

  DateTime? get tacLastVerifiedAt => _termsAndConditionsLastVerifiedAt;
  String? get version => _termsAndConditionsAcceptedVersion;

  void setTermsAndConditionsLastVerifiedAt(DateTime verified, String version) {
    _setTermsAndConditionsLastVerifiedAt(verified, version);
  }

  void resetCheckTime() {
    _setTermsAndConditionsLastVerifiedAt(null, _termsAndConditionsAcceptedVersion);
  }

  void resetVersion() {
    _setTermsAndConditionsLastVerifiedAt(_termsAndConditionsLastVerifiedAt, null);
  }

  void _setTermsAndConditionsLastVerifiedAt(DateTime? verified, String? version) {
    refreshTac = _shouldRefreshTacAfterUpdate(verified, version);

    _termsAndConditionsLastVerifiedAt = verified;
    _termsAndConditionsAcceptedVersion = version;
    notifyListeners();
  }

  bool _shouldRefreshTacAfterUpdate(DateTime? newVerified, String? newVersion) {
    return newVerified == null ||
      newVersion == null ||
      (_termsAndConditionsLastVerifiedAt != null && DateTime.now().difference(_termsAndConditionsLastVerifiedAt!).inMinutes > 1) ||
      (_termsAndConditionsAcceptedVersion != null && _termsAndConditionsAcceptedVersion != newVersion);
  }

  void printDiff() {
    if (_termsAndConditionsLastVerifiedAt != null) {
      print('diff: ${DateTime.now().difference(_termsAndConditionsLastVerifiedAt!).inMinutes}');
    }
  }
}
