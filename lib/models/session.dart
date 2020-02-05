import 'package:json_annotation/json_annotation.dart';

import 'package:method_conf_app/models/speaker.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  String title;
  String url;
  String status;
  String description;
  String time;
  String type;
  Speaker speaker;

  Session({
    this.title,
    this.url,
    this.status,
    this.description,
    this.time,
    this.type,
    this.speaker,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
