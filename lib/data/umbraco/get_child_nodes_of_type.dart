import 'package:method_conf_app/data/umbraco/get_items.dart';
import 'package:method_conf_app/data/umbraco/models/api_content_response_model_base.dart';

Future<List<ApiContentResponseModelBase>> getChildNodesOfType({
  required String nodeId,
  required String type,
  int take = 10,
}) async {
  var res = await getItems(
    filter: ['contentType:$type'],
    fetch: 'descendants:$nodeId',
    take: take,
  );

  return res.items;
}

Future<ApiContentResponseModelBase> getFirstChildNodeOfType({
  required String nodeId,
  required String type,
}) async {
  var items = await getChildNodesOfType(nodeId: nodeId, type: type);

  return items.first;
}
