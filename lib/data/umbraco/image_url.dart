import 'package:method_conf_app/env.dart';

String imageUrl(String url, {int? width, int? height}) {
  var parsedUrl = Uri.parse(Env.umbracoBaseUrl).replace(path: url);

  if (width != null) {
    parsedUrl = parsedUrl.replace(queryParameters: {'width': width.toString()});
  }

  if (height != null) {
    parsedUrl = parsedUrl.replace(
      queryParameters: {'height': height.toString()},
    );
  }

  return parsedUrl.toString();
}
