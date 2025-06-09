import 'package:json_annotation/json_annotation.dart';

import 'api_content_model_base.dart';

part 'paged_api_content_response_model.g.dart';

@JsonSerializable()
class PagedApiContentResponseModel {
  int total;
  List<ApiContentModelBase> items;

  PagedApiContentResponseModel({required this.total, required this.items});

  factory PagedApiContentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PagedApiContentResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PagedApiContentResponseModelToJson(this);
}
