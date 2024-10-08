import 'package:method_conf_app/data/umbraco/get_items.dart';
import 'package:method_conf_app/data/umbraco/models/conference.dart';

Future<Conference?> getDefaultConference() async {
  var response = await getItems(filter: ['contentType:conference']);

  Conference? latestConference;

  for (final conference in response.items) {
    if (conference is! Conference) {
      continue;
    }

    final date = conference.properties?.date;

    if (date == null) {
      continue;
    }

    if (latestConference == null ||
        (latestConference.properties?.date?.isBefore(date) ?? true)) {
      latestConference = conference;
    }
  }

  return latestConference;
}
