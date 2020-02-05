import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SessionProvider extends ChangeNotifier {
  void fetchInitialSession() async {
    await _fetchSession();
  }

  Future<void> _fetchSession() async {
    var url = '${DotEnv().env['METHOD_BASE_URL']}/sessions.json';
    var res = await http.get(url);
    var parsed = json.decode(res.body);

    print(parsed);
  }
}