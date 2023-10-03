import 'package:json_annotation/json_annotation.dart';
part 'wallet_proxy_model.g.dart';

@JsonSerializable()
class Toc {
  final String url;
  final String version;

  Toc(this.url, this.version);

  factory Toc.fromJson(Map<String, dynamic> json) => _$TocFromJson(json);

  Map<String, dynamic> toJson() => _$TocToJson(this);
}
