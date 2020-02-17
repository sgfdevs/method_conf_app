import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sentry/flutter_sentry.dart';
import 'package:method_conf_app/env.dart';

import 'package:method_conf_app/app.dart';


Future<void> main() => FlutterSentry.wrap(
  () async => runApp(App()),
  dsn: Env.sentryDsn,
);
