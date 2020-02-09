import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: false, forceSafariVC: false);
    return;
  }

  Fluttertoast.showToast(
    msg: 'Could not open url $url',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}


String daySuffix(int day) {
  var suffix = 'th';
  var digit = day % 10;

  if ((digit > 0 && digit < 4) && (day < 11 || day > 13)) {
    suffix = ['st', 'nd', 'rd'][digit - 1];
  }

  return suffix;
}
