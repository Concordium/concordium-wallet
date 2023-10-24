import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InheritedHiveBox extends InheritedWidget {
  final AppHiveBox appPrefs;

  const InheritedHiveBox(
      {super.key, required this.appPrefs, required super.child});

  static InheritedHiveBox of(BuildContext context) {
    final i = context
        .dependOnInheritedWidgetOfExactType<InheritedHiveBox>();
    assert(
        i != null, "No 'InheritedSharedPreferences' found above in the tree");
    return i!;
  }

  @override
  bool updateShouldNotify(covariant oldWidget) {
    return false;
  }
}

class AppHiveBox {
  static const _tacAcceptedVersionKey = 'tac:accepted_version';
  static const _tacLastAcceptedKey = 'tac:accepted_datetime';

  Box box;

  AppHiveBox({required this.box});

  String? get termsAndConditionsAcceptedVersion => box.get(_tacAcceptedVersionKey)?.version;
  
  static Future<AppHiveBox> init() async {
    await Hive.initFlutter();
    var box = await Hive.openBox("tac");
    return AppHiveBox(box: box);
  }

  DateTime? get termsAndConditionsLastAccepted {
    var lastAccept = box.get(_tacLastAcceptedKey)?.latest;
    if (lastAccept == null) {
      return null;
    }
    return lastAccept;
  }

  Future<void> update(DateTime? verified, String? version) async {
    if (verified == null) {
      await box.delete(_tacLastAcceptedKey);
    } else {
      await box.put(_tacLastAcceptedKey, verified);
    }
    if (version == null) {
      await box.delete(_tacAcceptedVersionKey);
    } else {
      await box.put(_tacAcceptedVersionKey, version);
    }
  }
}
