import 'package:json_annotation/json_annotation.dart';

part 'schedule_grid.g.dart';

@JsonSerializable()
class ScheduleGrid {
  List<List<String?>> scheduleGrid;

  ScheduleGrid({required this.scheduleGrid});

  factory ScheduleGrid.fromJson(Map<String, dynamic> json) =>
      _$ScheduleGridFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleGridToJson(this);
}
