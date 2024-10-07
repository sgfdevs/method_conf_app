import 'package:method_conf_app/data/umbraco/get_items.dart';

Future<dynamic> getChildNodesOfType({
  required String nodeId,
  required String type,
  int take = 10,
}) async {
  return await getItems(
    filter: ['contentType:$type'],
    fetch: 'descendants:$nodeId',
    take: take,
  );
}

Future<dynamic> getFirstChildNodeOfType({
  required String nodeId,
  required String type,
}) async {
  var childNodes = await getItems(
    filter: ['contentType:$type'],
    fetch: 'descendants:$nodeId',
    take: 1,
  );

  return childNodes.first;
}
