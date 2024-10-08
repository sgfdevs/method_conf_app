import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/sponsor.dart';
import 'package:method_conf_app/data/umbraco/models/sponsor_tier.dart';

part 'api_block_list_model.g.dart';

@JsonSerializable()
class ApiBlockListModel {
  List<ApiBlockItemModel> items;

  ApiBlockListModel({this.items = const []});

  factory ApiBlockListModel.fromJson(Map<String, dynamic> json) =>
      _$ApiBlockListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBlockListModelToJson(this);
}

@JsonSerializable()
class ApiBlockItemModel {
  ApiElementModel content;
  ApiElementModel? settings;

  ApiBlockItemModel({required this.content, this.settings});

  factory ApiBlockItemModel.fromJson(Map<String, dynamic> json) =>
      _$ApiBlockItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiBlockItemModelToJson(this);
}

@JsonSerializable()
class ApiElementModel {
  String id;
  String contentType;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Map<String, dynamic>? unParsedProperties;

  ApiElementModel({
    required this.id,
    required this.contentType,
    this.unParsedProperties,
  });

  factory ApiElementModel.fromJson(Map<String, dynamic> json) =>
      switch (json['contentType'] as String) {
        'sponsorTier' => SponsorTier.fromJson(json),
        'sponsor' => Sponsor.fromJson(json),
        _ => _fromJson(json),
      };

  static ApiElementModel _fromJson(Map<String, dynamic> json) {
    var obj = _$ApiElementModelFromJson(json);
    obj.unParsedProperties = json['properties'] as Map<String, dynamic>?;
    return obj;
  }

  Map<String, dynamic> toJson() => _$ApiElementModelToJson(this);
}
