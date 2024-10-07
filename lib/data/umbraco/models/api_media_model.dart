import 'package:json_annotation/json_annotation.dart';

part 'api_media_model.g.dart';

@JsonSerializable()
class ApiMediaModel {
  String id;
  String name;
  String mediaType;
  String url;
  String? extension;
  int? width;
  int? height;
  int? bytes;
  Map<String, dynamic> properties;

  ApiMediaModel({
    required this.id,
    required this.name,
    required this.mediaType,
    required this.url,
    required this.extension,
    required this.width,
    required this.height,
    required this.bytes,
    required this.properties,
  });

  factory ApiMediaModel.fromJson(Map<String, dynamic> json) =>
      _$ApiMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiMediaModelToJson(this);
}