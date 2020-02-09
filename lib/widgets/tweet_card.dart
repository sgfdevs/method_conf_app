import 'package:flutter/material.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:tweet_ui/tweet_view.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;

  const TweetCard({Key key, this.tweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          launchUrl(_tweetLink);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutralLight, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: TweetView.fromTweet(
            tweet,
            quoteBorderColor: AppColors.neutralLight,
            useVideoPlayer: false,
          ),
        ),
      ),
    );
  }

  String get _tweetLink {
    if (tweet.id <= 0) {
      return null;
    }

    if (tweet.user.screenName.isEmpty) {
      return "https://twitter.com/twitter_unknown/status/${tweet.idStr}";
    } else {
      return "https://twitter.com/${tweet.user.screenName}/status/${tweet.idStr}";
    }
  }
}
