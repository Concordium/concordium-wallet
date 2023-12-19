import 'package:hive/hive.dart';

part 'secret_box.g.dart';

@HiveType(typeId: 2)
class SecretBoxEntity {
  static const table = "secret_box";

  @HiveField(0)
  final List<int> cipherText;
  @HiveField(1)
  final List<int> nonce;
  @HiveField(2)
  final List<int> mac;

  SecretBoxEntity({required this.cipherText, required this.nonce, required this.mac});
}
