import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:method_conf_app/utils/error_tracking.dart';
import 'package:method_conf_app/app.dart';

void main() {
  ErrorTracker errorTracker;

  FlutterError.onError =
      (FlutterErrorDetails details, {bool forceReport = false}) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    } else {
      errorTracker.reportError(details.exception, details.stack);
    }
  };

  runZoned(
    () async {
      await DotEnv().load('.env');
      errorTracker = ErrorTracker();
      runApp(App());
    },
    onError: (error, stackTrace) {
      errorTracker.reportError(error, stackTrace);
    },
  );
}
