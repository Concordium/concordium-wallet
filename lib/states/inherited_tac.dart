import 'dart:convert';

import 'package:flutter/material.dart';

class InheritedTac extends InheritedWidget {
  final TacState tacState;

  InheritedTac({
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


class RestorableTacState extends RestorableChangeNotifier<TacState> {
  @override
  TacState createDefaultValue() {
    return TacState();
  }
  
  @override
  TacState fromPrimitives(Object? data) {
    if (data != null) {
      Map<String, dynamic> tacStateMap = jsonDecode(data as String);
      return TacState.fromJson(tacStateMap);
    }
    return TacState();
  }
  
  @override
  Object? toPrimitives() {
    String json = jsonEncode(this);
    return json;
  }
}

class TacState extends ChangeNotifier {
  DateTime? _termsAndConditionsLastVerifiedAt;
  String? _termsAndConditionsAcceptedVersion;
  bool _refreshTac = true;

  DateTime? get tacLastVerifiedAt => _termsAndConditionsLastVerifiedAt;
  String? get version => _termsAndConditionsAcceptedVersion;
  bool get refreshTac => _refreshTac;

  TacState();

  TacState.fromJson(Map<String, dynamic> json)
    : _termsAndConditionsLastVerifiedAt = json['verified'],
      _termsAndConditionsAcceptedVersion = json['version'],
      _refreshTac = json['refresh'];
  
  Map<String, dynamic> toJson() => {
    'verified': _termsAndConditionsLastVerifiedAt,
    'version': _termsAndConditionsAcceptedVersion,
    'refresh': refreshTac
  };

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
    _refreshTac = _shouldRefreshTacAfterUpdate(verified, version);

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
