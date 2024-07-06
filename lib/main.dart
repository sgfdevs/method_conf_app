import 'dart:async';

import 'package:flutter/material.dart';
import 'package:method_conf_app/env.dart';

import 'package:method_conf_app/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


Future main() async {
  if (!Env.enableErrorTracking) {
    return start();
  }

  return SentryFlutter.init(
        (options) {
      options.dsn = Env.sentryDsn;
    },
    appRunner: start,
  );
}

Future start() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(App());
}