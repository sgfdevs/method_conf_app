import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_block_list_model.dart';
import 'package:method_conf_app/data/umbraco/models/sponsor.dart';

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

String readLowerCase(Map<dynamic, dynamic> json, String key) {
  return json[key].toString().toLowerCase();
}

@JsonSerializable()
class SponsorTierProperties {
  String? title;
  @JsonKey(readValue: readLowerCase)
  SponsorTierLogoSize logoSizes;
  @JsonKey(name: 'sponsors')
  ApiBlockListModel? sponsorsBlockList;

  @JsonKey(includeToJson: false)
  List<Sponsor> get sponsors =>
      sponsorsBlockList?.items
          .map((item) => item.content)
          .whereType<Sponsor>()
          .toList() ??
      [];

  @JsonKey(includeToJson: false)
  List<Sponsor> get mobileAppSponsors => sponsors
      .where((sponsor) => sponsor.properties?.mobileAppSponsor ?? false)
      .toList();

  SponsorTierProperties({
    this.title,
    this.logoSizes = SponsorTierLogoSize.medium,
    this.sponsorsBlockList,
  });

  factory SponsorTierProperties.fromJson(Map<String, dynamic> json) =>
      _$SponsorTierPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorTierPropertiesToJson(this);
}

@JsonEnum()
enum SponsorTierLogoSize {
  large,
  medium,
  small,
}
