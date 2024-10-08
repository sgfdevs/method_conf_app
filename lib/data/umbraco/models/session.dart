import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';
import 'package:method_conf_app/data/umbraco/models/rich_text_model.dart';
import 'package:method_conf_app/data/umbraco/models/speaker.dart';
import 'package:method_conf_app/utils/cst_utils.dart';

part 'session.g.dart';

@JsonSerializable()
class Session extends ApiContentModelBase {
  SessionProperties? properties;

  Session({
    required super.contentType,
    required super.name,
    required super.createDate,
    required super.updateDate,
    required super.route,
    required super.id,
    this.properties,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}

@JsonSerializable()
class SessionProperties {
  @JsonKey(fromJson: utcStringToCst, toJson: cstToUtcString)
  DateTime? start;
  @JsonKey(fromJson: utcStringToCst, toJson: cstToUtcString)
  DateTime? end;
  bool isEligibleForFeedback;
  RichTextModel? description;
  @JsonKey(name: 'speakers')
  List<ApiContentModelBase> speakerContentItems;

  List<Speaker> get speakers =>
      speakerContentItems.whereType<Speaker>().toList();

  SessionProperties({
    this.start,
    this.end,
    this.isEligibleForFeedback = false,
    this.description,
    this.speakerContentItems = const [],
  });

  factory SessionProperties.fromJson(Map<String, dynamic> json) =>
      _$SessionPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$SessionPropertiesToJson(this);
}
