import 'package:method_conf_app/data/umbraco/get_child_nodes_of_type.dart';
import 'package:method_conf_app/data/umbraco/get_items.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_model_base.dart';
import 'package:method_conf_app/data/umbraco/models/session.dart';
import 'package:method_conf_app/data/umbraco/models/track.dart';

const maximumScheduleItems = 100;

Future<List<ApiContentModelBase>> getScheduleItems(conferenceId) async {
  final sessions = await getFirstChildNodeOfType(
    nodeId: conferenceId,
    type: 'sessions',
  );

  if (sessions == null) {
    return [];
  }

  var response = await getItems(
    fetch: 'descendants:${sessions.id}',
    expand: 'properties[\$all]',
    take: 100,
  );

  return response.items
      .where((item) => item is Track || item is Session)
      .toList();
}
