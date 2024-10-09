import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_block_list_model.dart';
import 'package:method_conf_app/data/umbraco/models/api_media_model.dart';

part 'sponsor.g.dart';

@JsonSerializable()
class Sponsor extends ApiElementModel {
  SponsorProperties? properties;

  Sponsor({
    required super.id,
    required super.contentType,
    this.properties,
  });

  factory Sponsor.fromJson(Map<String, dynamic> json) =>
      _$SponsorFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SponsorToJson(this);
}

@JsonSerializable()
class SponsorProperties {
  String? title;
  @JsonKey(name: 'logo')
  List<ApiMediaModel> logos;
  bool darkBackground;
  bool mobileAppSponsor;
  String? url;

  ApiMediaModel? get logo => logos.firstOrNull;

  SponsorProperties({
    this.title,
    this.logos = const [],
    this.darkBackground = false,
    this.mobileAppSponsor = false,
    this.url,
  });

  factory SponsorProperties.fromJson(Map<String, dynamic> json) =>
      _$SponsorPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SponsorPropertiesToJson(this);
}
