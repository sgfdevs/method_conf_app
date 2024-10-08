import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_link_model.dart';
import 'package:method_conf_app/utils/cst_utils.dart';

import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';

part 'conference.g.dart';

@JsonSerializable()
class Conference extends ApiContentModelBase {
  ConferenceProperties? properties;

  Conference({
    required super.contentType,
    required super.name,
    required super.createDate,
    required super.updateDate,
    required super.route,
    required super.id,
    required this.properties,
  });

  factory Conference.fromJson(Map<String, dynamic> json) =>
      _$ConferenceFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConferenceToJson(this);
}

@JsonSerializable()
class ConferenceProperties {
  @JsonKey(fromJson: utcStringToCst, toJson: cstToUtcString)
  DateTime? date;
  String? registerUrl;
  String? callForSpeakersUrl;
  String? tagline;
  String? location;
  List<ApiLinkModel> mobileAppLinks;
  @JsonKey(fromJson: utcStringToCst, toJson: cstToUtcString)
  DateTime? surveyAvailableAt;
  @JsonKey(name: 'surveyUrl')
  List<ApiLinkModel> surveyUrlList;

  ApiLinkModel? get surveyUrl => surveyUrlList.firstOrNull;

  ConferenceProperties({
    this.date,
    this.registerUrl,
    this.callForSpeakersUrl,
    this.tagline,
    this.location,
    this.mobileAppLinks = const [],
    this.surveyAvailableAt,
    this.surveyUrlList = const [],
  });

  factory ConferenceProperties.fromJson(Map<String, dynamic> json) =>
      _$ConferencePropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$ConferencePropertiesToJson(this);
}
