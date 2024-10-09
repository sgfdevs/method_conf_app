import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';
import 'package:method_conf_app/data/umbraco/models/api_media_model.dart';
import 'package:method_conf_app/data/umbraco/models/rich_text_model.dart';

part 'speaker.g.dart';

@JsonSerializable()
class Speaker extends ApiContentModelBase {
  SpeakerProperties? properties;

  Speaker({
    required super.contentType,
    required super.createDate,
    required super.updateDate,
    required super.route,
    required super.id,
    this.properties,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) =>
      _$SpeakerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SpeakerToJson(this);
}

@JsonSerializable()
class SpeakerProperties {
  String? jobTitle;
  @JsonKey(name: 'profileImage')
  List<ApiMediaModel> profileImages;
  RichTextModel? bio;
  String? websiteUrl;
  String? xTwitterUrl;
  String? linkedInUrl;
  String? instagramUrl;

  ApiMediaModel? get profileImage => profileImages.firstOrNull;

  SpeakerProperties({
    this.jobTitle,
    this.profileImages = const [],
    this.bio,
    this.websiteUrl,
    this.xTwitterUrl,
    this.linkedInUrl,
    this.instagramUrl,
  });

  factory SpeakerProperties.fromJson(Map<String, dynamic> json) =>
      _$SpeakerPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SpeakerPropertiesToJson(this);
}
