import 'dart:async';

import 'package:flutter/material.dart';

import 'package:method_conf_app/utils/error_tracking.dart';
import 'package:method_conf_app/app.dart';


void main() {
  var errorTracker = ErrorTracker();

  runZoned(
    () => runApp(App()),
    onError: (error, stackTrace) {
      errorTracker.reportError(error, stackTrace);
    },
  );

  FlutterError.onError = (FlutterErrorDetails details, {bool forceReport = false}) {
    if (!isInDebugMode) {
      errorTracker.reportError(details.exception, details.stack);
    }

    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  };
}
