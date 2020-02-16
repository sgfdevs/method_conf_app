import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_html.dart';

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

Future<void> showErrorDialog({
  @required context,
  @required String message,
  String title = 'Whoops',
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: IntrinsicHeight(child: AppHtml(markup: message)),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Ok',
              style: TextStyle(color: AppColors.accent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

double degreesToRads(double deg) {
  return (deg * pi) / 180.0;
}
