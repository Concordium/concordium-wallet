import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InheritedSharedPreferences extends InheritedWidget {
  final AppSharedPreferences appPrefs;

  InheritedSharedPreferences(
      {super.key, required SharedPreferences prefs, required super.child})
      : appPrefs = AppSharedPreferences(prefs);

  static InheritedSharedPreferences of(BuildContext context) {
    final i = context
        .dependOnInheritedWidgetOfExactType<InheritedSharedPreferences>();
    assert(
        i != null, "No 'InheritedSharedPreferences' found above in the tree");
    return i!;
  }

  @override
  bool updateShouldNotify(covariant oldWidget) {
    return false;
  }
}

class AppSharedPreferences {
  static const _tacAcceptedVersionKey = 'tac:accepted_version';
  static const _tacLastAcceptedKey = 'tac:accepted_datetime';

  final SharedPreferences _prefs;

  AppSharedPreferences(this._prefs);

  String? get termsAndConditionsAcceptedVersion =>
      _prefs.getString(_tacAcceptedVersionKey);
  DateTime? get termsAndConditionsLastAccepted {
    var lastAccept = _prefs.getString(_tacLastAcceptedKey);
    if (lastAccept == null) {
      return null;
    }
    return DateTime.parse(lastAccept);
  }

  Future<void> update(DateTime? verified, String? version) async {
    if (verified == null) {
      await _prefs.remove(_tacLastAcceptedKey);
    } else {
      var dateTime = verified.toString();
      await _prefs.setString(_tacLastAcceptedKey, dateTime);
    }
    if (version == null) {
      await _prefs.remove(_tacAcceptedVersionKey);
    } else {
      await _prefs.setString(_tacAcceptedVersionKey, version);
    }
  }
}
