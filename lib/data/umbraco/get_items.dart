import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:method_conf_app/data/umbraco/models/paged_api_content_response_model.dart';

import 'package:method_conf_app/env.dart';

Future<PagedApiContentResponseModel> getItems(
    {List<String> filter = const [], String? fetch, int? take}) async {
  var url = Uri.parse('${Env.umbracoBaseUrl}/umbraco/delivery/api/v2/content');

  if (filter.isNotEmpty) {
    url = url
        .replace(queryParameters: {...url.queryParameters, 'filter': filter});
  }

  if (fetch != null) {
    url =
        url.replace(queryParameters: {...url.queryParameters, 'fetch': fetch});
  }

  if (take != null) {
    url = url.replace(
        queryParameters: {...url.queryParameters, 'take': take.toString()});
  }

  var res = await http.get(url);

  return PagedApiContentResponseModel.fromJson(json.decode(res.body));
}
