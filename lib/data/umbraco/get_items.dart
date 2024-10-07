import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';

Future<List<dynamic>> getItems(
    {List<String> filter = const [], String? fetch, int? take}) async {
  var url = Uri.parse('${Env.umbracoBaseUrl}/umbraco/delivery/api/v2/content');

  if (filter.isNotEmpty) {
    url.replace(queryParameters: {...url.queryParameters, 'filter': filter});
  }

  if (fetch != null) {
    url.replace(queryParameters: {...url.queryParameters, 'fetch': fetch});
  }

  if (take != null) {
    url.replace(
        queryParameters: {...url.queryParameters, 'take': take.toString()});
  }

  var res = await http.get(url);

  return json.decode(res.body) as List<dynamic>;
}
