import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:http/http.dart' as http;

import 'package:method_conf_app/env.dart';

class TwitterProvider extends ChangeNotifier {
  bool _initialFetched = false;

  List<Tweet> _tweets = [];

  List<Tweet> get tweets => _tweets;

  set tweets(List<Tweet> newTweets) {
    _tweets = newTweets;
    notifyListeners();
  }

  Future<void> fetchInitialTweets() async {
    if (_initialFetched) {
      fetchTweets();
    } else {
      await fetchTweets();
    }

    _initialFetched = true;
  }

  Future<void> fetchTweets() async {
    var url = '${Env.methodBaseUrl}/actions/twitter-module/search';
    var res = await http.get(url);

    tweets = (json.decode(res.body)['statuses'] as List<dynamic>)
        .map((status) => Tweet.fromJson(status))
        .toList();
  }
}
