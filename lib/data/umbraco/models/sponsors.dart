import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_block_list_model.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_response_model_base.dart';

part 'sponsors.g.dart';

@JsonSerializable()
class Sponsors extends ApiContentResponseModelBase {
  SponsorsProperties? properties;

  Sponsors({
    required super.contentType,
    required super.name,
    required super.createDate,
    required super.updateDate,
    required super.route,
    required super.id,
    required super.cultures,
    required this.properties,
  });

  factory Sponsors.fromJson(Map<String, dynamic> json) =>
      _$SponsorsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SponsorsToJson(this);
}

@JsonSerializable()
class SponsorsProperties {
  ApiBlockListModel? tiers;

  SponsorsProperties({this.tiers});

  factory SponsorsProperties.fromJson(Map<String, dynamic> json) =>
      _$SponsorsPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorsPropertiesToJson(this);
}
