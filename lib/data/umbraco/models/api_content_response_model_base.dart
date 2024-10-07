import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/conference.dart';
import 'package:method_conf_app/data/umbraco/models/sponsors.dart';

part 'api_content_response_model_base.g.dart';

@JsonSerializable()
class ApiContentResponseModelBase {
  String contentType;
  String name;
  DateTime createDate;
  DateTime updateDate;
  ApiContentRouteModel route;
  String id;
  Map<String, ApiContentRouteModel> cultures;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? unParsedProperties;

  ApiContentResponseModelBase(
      {required this.contentType,
      required this.name,
      required this.createDate,
      required this.updateDate,
      required this.route,
      required this.id,
      required this.cultures,
      this.unParsedProperties});

  factory ApiContentResponseModelBase.fromJson(Map<String, dynamic> json) =>
      switch (json['contentType'] as String) {
        'conference' => Conference.fromJson(json),
        'sponsors' => Sponsors.fromJson(json),
        _ => _fromJson(json),
      };

  static ApiContentResponseModelBase _fromJson(Map<String, dynamic> json) {
    var obj = _$ApiContentResponseModelBaseFromJson(json);
    obj.unParsedProperties = json['properties'] as Map<String, dynamic>?;
    return obj;
  }

  Map<String, dynamic> toJson() => _$ApiContentResponseModelBaseToJson(this);
}

@JsonSerializable()
class ApiContentRouteModel {
  String path;
  ApiContentStartItemModel startItem;

  ApiContentRouteModel({
    required this.path,
    required this.startItem,
  });

  factory ApiContentRouteModel.fromJson(Map<String, dynamic> json) =>
      _$ApiContentRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiContentRouteModelToJson(this);
}

@JsonSerializable()
class ApiContentStartItemModel {
  String id;
  String path;

  ApiContentStartItemModel({
    required this.id,
    required this.path,
  });

  factory ApiContentStartItemModel.fromJson(Map<String, dynamic> json) =>
      _$ApiContentStartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiContentStartItemModelToJson(this);
}
