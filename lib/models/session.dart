import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:method_conf_app/env.dart';
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

  DateTime get dateTime {
    var date = Env.eventDate;
    var begin = time.split('–')[0];
    begin = begin.split('-')[0];
    begin = begin.replaceAll('PM', ' PM').replaceAll('AM', ' AM');

    var format = DateFormat('yyyy-MM-dd hh:mm a');


    return format.parse('$date $begin');
  }

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
