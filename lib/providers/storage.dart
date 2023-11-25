import 'package:concordium_wallet/entities/accepted_terms_and_conditions.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Service for interacting with [Hive].
class StorageProvider {
  final LazyBox<AcceptedTermsAndConditions> _acceptedTermsAndConditionBox;

  const StorageProvider._(this._acceptedTermsAndConditionBox);

  static Future<StorageProvider> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();

    return StorageProvider._(Hive.lazyBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table));
  }

  /// Register all adapters needed for typed boxes.
  static void _registerAdapters() {
    Hive.registerAdapter(AcceptedTermsAndConditionsAdapter());
    Hive.registerAdapter(PerciseDateTimeAdapter(), override: true, internal: true);
  }

  /// Opens all boxes asynchronously.
  static Future<void> _openBoxes() async {
    final atcFuture = Hive.openLazyBox<AcceptedTermsAndConditions>(AcceptedTermsAndConditions.table);
    await Future.wait([atcFuture]);
  }

  LazyBox<AcceptedTermsAndConditions> get acceptedTermsAndConditionBox => _acceptedTermsAndConditionBox;
}

/// A bit modified DateTimeWithTimezoneAdapter (https://github.com/hivedb/hive/blob/master/hive/lib/src/adapters/date_time_adapter.dart#L25-L42)
/// This adapter is relevant because by default, [Hive] only stores datetimes down to millisecond precision. 
/// It's derived from issue in link and proposed as a solution (https://github.com/isar/hive/issues/474#issuecomment-730562545).
class PerciseDateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  final typeId = 18;

  @override
  DateTime read(BinaryReader reader) {
    var micros = reader.readInt();
    var isUtc = reader.readBool();
    return DateTime.fromMicrosecondsSinceEpoch(micros, isUtc: isUtc);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.microsecondsSinceEpoch);
    writer.writeBool(obj.isUtc);
  }
}
