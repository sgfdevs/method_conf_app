import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_block_list_model.dart';

part 'sponsor_tier.g.dart';

@JsonSerializable()
class SponsorTier extends ApiElementModel {
  SponsorTierProperties? properties;

  SponsorTier({
    required super.id,
    required super.contentType,
    this.properties,
  });

  factory SponsorTier.fromJson(Map<String, dynamic> json) =>
      _$SponsorTierFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SponsorTierToJson(this);
}

@JsonSerializable()
class SponsorTierProperties {
  String? title;
  String? logoSizes;
  ApiBlockListModel? sponsors;

  SponsorTierProperties({
    this.title,
    this.logoSizes,
    this.sponsors,
  });

  factory SponsorTierProperties.fromJson(Map<String, dynamic> json) =>
      _$SponsorTierPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorTierPropertiesToJson(this);
}
