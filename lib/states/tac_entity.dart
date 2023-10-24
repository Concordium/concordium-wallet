
import 'package:hive/hive.dart';

part 'tac_entity.g.dart';

@HiveType(typeId: 1)
class TacEntity {
  @HiveField(1)
  late String version;

  @HiveField(2)
  late DateTime latest;
}
