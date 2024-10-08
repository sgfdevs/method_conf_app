import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_block_list_model.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_response_model_base.dart';
import 'package:method_conf_app/data/umbraco/models/api_link_model.dart';
import 'package:method_conf_app/data/umbraco/models/sponsor_tier.dart';

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
  @JsonKey(name: 'tiers')
  ApiBlockListModel? tiersBlockList;
  @JsonKey(name: 'opportunitiesUrl')
  List<ApiLinkModel> opportunitiesUrlList;

  @JsonKey(includeToJson: false)
  List<SponsorTier> get tiers =>
      tiersBlockList?.items
          .map((item) => item.content)
          .whereType<SponsorTier>()
          .toList() ??
      [];

  @JsonKey(includeToJson: false)
  ApiLinkModel? get opportunitiesUrl => opportunitiesUrlList.firstOrNull;

  SponsorsProperties(
      {this.tiersBlockList, this.opportunitiesUrlList = const []});

  factory SponsorsProperties.fromJson(Map<String, dynamic> json) =>
      _$SponsorsPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorsPropertiesToJson(this);
}
