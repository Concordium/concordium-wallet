import 'dart:core';

import 'package:concordium_wallet/states/tac_entity.dart';
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
  static const _tacKey = 'tacExample';

  Box box;
  Box<TacEntity> boxExample;

  AppHiveBox({required this.box, required this.boxExample});

  String? get termsAndConditionsAcceptedVersion => box.get(_tacAcceptedVersionKey);
  String? get versionExample => boxExample.get(_tacKey)?.version;
  DateTime? get termsAndConditionsLastAccepted {
    DateTime? lastAccept = box.get(_tacLastAcceptedKey);
    if (lastAccept == null) { 
      return null;
    }
    return lastAccept;
  }
  
  static Future<AppHiveBox> init() async {
    await Hive.initFlutter();
    var box = await Hive.openBox("tac");
    var boxExample = await Hive.openBox<TacEntity>("tacExample");
    return AppHiveBox(box: box, boxExample: boxExample);
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
