import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:method_conf_app/theme.dart';

Future<void> launchUrl(String url) async {
  try {
    final parsed = Uri.parse(url);
    await url_launcher.launchUrl(
      parsed,
      mode: url_launcher.LaunchMode.externalApplication,
    );
    return;
  } catch (e) {
    // ignore errors
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
  required context,
  required String message,
  String title = 'Whoops',
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Ok',
              style: TextStyle(color: AppColors.accent, fontSize: 18),
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
