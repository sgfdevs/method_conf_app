import 'package:flutter/material.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/app_icons.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/page_loader.dart';
import 'package:method_conf_app/widgets/tweet_card.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/providers/twitter_provider.dart';
import 'package:method_conf_app/widgets/app_screen.dart';
import 'package:tweet_ui/models/api/tweet.dart';
import 'package:tweet_ui/tweet_ui.dart';

class SocialFeedScreen extends StatefulWidget {
  @override
  _SocialFeedScreenState createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  Future _tweetFuture;

  @override
  void initState() {
    super.initState();

    var twitterProvider = Provider.of<TwitterProvider>(context, listen: false);

    _tweetFuture = twitterProvider.fetchInitialTweets();
  }

  @override
  Widget build(BuildContext context) {
    var twitterProvider = Provider.of<TwitterProvider>(context);

    return AppScreen(
      title: 'Happening Now',
      body: PageLoader(
        future: _tweetFuture,
        child: RefreshIndicator(
          onRefresh: () async {
            await twitterProvider.fetchTweets();
          },
//          child: SingleChildScrollView(
//            child: Column(
//              children: <Widget>[
//                _buildHeader(),
//                ...twitterProvider.tweets.map((tweet) {
//                  return _buildTweetCard(tweet);
//                }).toList(),
//              ],
//            ),
//          ),
          // Not sure if this is actually faster than normal ListView
          child: ListView.separated(
            padding: EdgeInsets.only(top: 0, bottom: 30),
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader();
              }

              return TweetCard(tweet: twitterProvider.tweets[index - 1]);
            },
            itemCount: twitterProvider.tweets.length + 1,
            separatorBuilder: (context, index) {
              return SizedBox(height: 30);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      color: AppColors.neutralExtraLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Announcements and Conversations',
            style: TextStyle(fontSize: 24),
          ),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Use '),
                TextSpan(
                  text: '#MethodConf',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' to participate now'),
              ],
            ),
          ),
          SizedBox(height: 15),
          FlatButton(
            padding: EdgeInsets.all(15),
            color: AppColors.twitterPrimary,
            onPressed: _onTweetButtonTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(AppIcons.twitter_logo, color: Colors.white),
                SizedBox(width: 15),
                Text(
                  'Tweet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onTweetButtonTap() {
    var text = Uri.encodeComponent('Invest In Yourself and Hone Your Craft');
    var url = 'https://methodconf.com';
    var hashtags = 'MethodConf';
    var parameters = '?text=$text&hashtags=$hashtags&url=$url';
    launchUrl('https://twitter.com/intent/tweet$parameters');
  }
}
