import 'package:method_conf_app/env.dart';
import 'package:plausible_analytics/plausible_analytics.dart';

final analytics = Plausible(Env.plausibleServerUrl, Env.plausibleDomain);
