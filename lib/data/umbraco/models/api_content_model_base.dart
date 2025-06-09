import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/conference.dart';
import 'package:method_conf_app/data/umbraco/models/session.dart';
import 'package:method_conf_app/data/umbraco/models/speaker.dart';
import 'package:method_conf_app/data/umbraco/models/sponsors.dart';
import 'package:method_conf_app/data/umbraco/models/track.dart';

part 'api_content_model_base.g.dart';

@JsonSerializable()
class ApiContentModelBase {
  String contentType;
  String? name;
  DateTime createDate;
  DateTime updateDate;
  ApiContentRouteModel route;
  String id;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? unParsedProperties;

  ApiContentModelBase({
    required this.contentType,
    this.name,
    required this.createDate,
    required this.updateDate,
    required this.route,
    required this.id,
    this.unParsedProperties,
  });

  factory ApiContentModelBase.fromJson(Map<String, dynamic> json) =>
      switch (json['contentType'] as String) {
        'conference' => Conference.fromJson(json),
        'sponsors' => Sponsors.fromJson(json),
        'track' => Track.fromJson(json),
        'session' => Session.fromJson(json),
        'speaker' => Speaker.fromJson(json),
        _ => _fromJson(json),
      };

  static ApiContentModelBase _fromJson(Map<String, dynamic> json) {
    var obj = _$ApiContentModelBaseFromJson(json);
    obj.unParsedProperties = json['properties'] as Map<String, dynamic>?;
    return obj;
  }

  Map<String, dynamic> toJson() {
    final json = _$ApiContentModelBaseToJson(this);
    json['properties'] = unParsedProperties;
    return json;
  }
}

@JsonSerializable()
class ApiContentRouteModel {
  String path;
  ApiContentStartItemModel startItem;

  ApiContentRouteModel({required this.path, required this.startItem});

  factory ApiContentRouteModel.fromJson(Map<String, dynamic> json) =>
      _$ApiContentRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiContentRouteModelToJson(this);
}

@JsonSerializable()
class ApiContentStartItemModel {
  String id;
  String path;

  ApiContentStartItemModel({required this.id, required this.path});

  factory ApiContentStartItemModel.fromJson(Map<String, dynamic> json) =>
      _$ApiContentStartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiContentStartItemModelToJson(this);
}
