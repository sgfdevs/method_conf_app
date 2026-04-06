import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import 'package:method_conf_app/app.dart';
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

  final messenger = appScaffoldMessengerKey.currentState;
  if (messenger == null) {
    return;
  }

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          'Could not open url $url',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.black.withValues(alpha: 0.88),
      ),
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
  required BuildContext context,
  required String message,
  String title = 'Whoops',
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message, style: TextStyle(fontSize: 16)),
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
