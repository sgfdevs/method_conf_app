import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:method_conf_app/data/umbraco/models/schedule_grid.dart';

import 'package:method_conf_app/env.dart';

Future<List<List<String?>>> getScheduleGrid(String conferenceId) async {
  var url = Uri.parse(
    '${Env.umbracoBaseUrl}/api/v1/conference/$conferenceId/schedule',
  );

  final res = await http.get(url);

  return ScheduleGrid.fromJson(json.decode(res.body)).scheduleGrid;
}
