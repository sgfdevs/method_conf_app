import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';

part 'track.g.dart';

@JsonSerializable()
class Track extends ApiContentModelBase {
  TrackProperties? properties;

  Track({
    required super.contentType,
    required super.name,
    required super.createDate,
    required super.updateDate,
    required super.route,
    required super.id,
    this.properties,
  });

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TrackToJson(this);
}

@JsonSerializable()
class TrackProperties {
  TrackProperties();

  factory TrackProperties.fromJson(Map<String, dynamic> json) =>
      _$TrackPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$TrackPropertiesToJson(this);
}
