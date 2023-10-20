import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_tac.g.dart';

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
    String json = jsonEncode(value);
    return json;
  }
}

@JsonSerializable()
class TacState extends ChangeNotifier {
  @JsonKey(name: 'verified', includeFromJson: true, includeToJson: true)
  DateTime? _termsAndConditionsLastVerifiedAt;
  @JsonKey(name: 'version', includeFromJson: true, includeToJson: true)
  String? _termsAndConditionsAcceptedVersion;
  @JsonKey(name: 'refresh', includeFromJson: true, includeToJson: true)
  bool _refreshTac = true;

  DateTime? get tacLastVerifiedAt => _termsAndConditionsLastVerifiedAt;
  String? get version => _termsAndConditionsAcceptedVersion;
  bool get refreshTac => _refreshTac;

  TacState();

  factory TacState.fromJson(Map<String, dynamic> json) => _$TacStateFromJson(json);
  
  Map<String, dynamic> toJson() => _$TacStateToJson(this);

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
