import 'package:json_annotation/json_annotation.dart';
part 'wallet_proxy_model.g.dart';

@JsonSerializable()
class Tac {
  final String url;
  final String version;

  Tac(this.url, this.version);

  factory Tac.fromJson(Map<String, dynamic> json) => _$TacFromJson(json);

  Map<String, dynamic> toJson() => _$TacToJson(this);
}
