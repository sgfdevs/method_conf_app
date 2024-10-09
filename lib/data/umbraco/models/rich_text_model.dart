import 'package:json_annotation/json_annotation.dart';
import 'package:method_conf_app/data/umbraco/models/api_block_list_model.dart';

part 'rich_text_model.g.dart';

@JsonSerializable()
class RichTextModel {
  String markup;
  List<ApiBlockItemModel> blocks;

  RichTextModel({
    required this.markup,
    this.blocks = const [],
  });

  factory RichTextModel.fromJson(Map<String, dynamic> json) =>
      _$RichTextModelFromJson(json);

  Map<String, dynamic> toJson() => _$RichTextModelToJson(this);
}
