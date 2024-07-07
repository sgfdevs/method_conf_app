import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:method_conf_app/env.dart';
import 'package:method_conf_app/models/speaker.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  String title;
  String? url;
  String? status;
  String? description;
  String? time;
  String? type;
  Speaker speaker;

  DateTime get beginTime {
    var begin = time!.split('–').first;
    begin = begin.split('-').first;
    begin = begin.replaceAll('PM', ' PM').replaceAll('AM', ' AM');

    var format = DateFormat('yyyy-MM-dd hh:mm a');

    return format.parse('${Env.eventDate} $begin');
  }

  DateTime get endTime {
    var end = time!.split('–').last;
    end = end.split('-').last;
    end = end
        .replaceAll('PM', ' PM')
        .replaceAll('AM', ' AM')
        .replaceAll(' (Lunch)', '');

    var format = DateFormat('yyyy-MM-dd hh:mm a');

    var date = format.parse('${Env.eventDate} $end');

    if (date == beginTime) {
      date = date.add(const Duration(hours: 1));
    }

    return date;
  }

  Session({
    required this.title,
    this.url,
    this.status,
    this.description,
    this.time,
    this.type,
    required this.speaker,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
