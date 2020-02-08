import 'package:sentry/sentry.dart';

import 'package:method_conf_app/env.dart';

bool get isInDebugMode {
  var inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

class ErrorTracker {
//  final SentryClient _sentry = new SentryClient(dsn: Env.sentryDsn);

  Future reportError(dynamic error, dynamic stackTrace) async {
    print('Caught error: $error');

    if (isInDebugMode) {
      print(stackTrace);
      return;
    }

    try {
//      await _sentry.captureException(
//        exception: error,
//        stackTrace: stackTrace,
//      );
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
      print('Original error: $error');
    }
  }
}
