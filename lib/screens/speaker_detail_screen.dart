import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/models/speaker.dart';
import 'package:method_conf_app/screens/not_found_screen.dart';
import 'package:method_conf_app/providers/session_provider.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/app_icons.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class SpeakerDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var speaker = ModalRoute.of(context).settings.arguments as Speaker;
    var session =
        Provider.of<SessionProvider>(context).getSessionForSpeaker(speaker);

    if (speaker == null) {
      return NotFoundScreen();
    }

    return AppScreen(
      title: 'Speaker',
      body: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            color: AppColors.neutralExtraLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  speaker.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: CachedNetworkImage(
                        imageUrl: speaker.image,
                        placeholder: (context, url) {
                          return Container(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.transparent),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(width: 20),
                    Flexible(
                      child: _buildSocialIcons(speaker),
                    ),
                  ],
                ),
                AppHtml(
                  markup: speaker.bio,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Speaking Sessions & Workshops',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 15),
                SessionExpansionTile(session: session, disableSpeakerTap: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSocialIcons(Speaker speaker) {
    var icons = <Widget>[];

    if (speaker.twitterUrl != null) {
      icons.add(InkWell(
//        padding: EdgeInsets.all(0),
        onTap: () => launchUrl(speaker.twitterUrl),
        child: Icon(AppIcons.twitter_logo, color: AppColors.accent, size: 35),
      ));
    }

    if (speaker.twitter2Url != null) {
      icons.add(InkWell(
        onTap: () => launchUrl(speaker.twitter2Url),
        child: Icon(AppIcons.twitter_logo, color: AppColors.accent, size: 35),
      ));
    }

    if (speaker.linkedinUrl != null) {
      icons.add(InkWell(
        onTap: () => launchUrl(speaker.linkedinUrl),
        child: Icon(AppIcons.linkedin_logo, color: AppColors.accent, size: 35),
      ));
    }

    if (speaker.githubUrl != null) {
      icons.add(InkWell(
        onTap: () => launchUrl(speaker.githubUrl),
        child: Icon(AppIcons.github_logo, color: AppColors.accent, size: 35),
      ));
    }

    if (speaker.websiteURL != null) {
      icons.add(InkWell(
        onTap: () => launchUrl(speaker.websiteURL),
        child: Icon(AppIcons.website_logo, color: AppColors.accent, size: 35),
      ));
    }

    return Wrap(
      children: icons,
      spacing: 30,
      runSpacing: 30,
    );
  }
}
