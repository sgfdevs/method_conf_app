import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:method_conf_app/data/umbraco/image_url.dart';
import 'package:method_conf_app/providers/schedule_provider.dart';
import 'package:provider/provider.dart';

import 'package:method_conf_app/data/umbraco/models/speaker.dart';
import 'package:method_conf_app/widgets/session_expansion_tile.dart';
import 'package:method_conf_app/screens/not_found_screen.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_screen.dart';

class SpeakerDetailScreen extends StatelessWidget {
  const SpeakerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var speaker = ModalRoute.of(context)!.settings.arguments as Speaker?;
    var sessions = Provider.of<ScheduleProvider>(
      context,
    ).getSessionsForSpeaker(speaker);

    if (speaker == null) {
      return const NotFoundScreen();
    }

    final bio = speaker.properties?.bio?.markup;
    final profileImageUrl = speaker.properties?.profileImage?.url;

    return AppScreen(
      title: 'Speaker',
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.neutralExtraLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  speaker.name ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  speaker.properties?.jobTitle ?? '',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (profileImageUrl != null)
                      Flexible(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl(
                            profileImageUrl,
                            width: 300,
                            height: 300,
                          ),
                          placeholder: (context, url) {
                            return const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.transparent,
                              ),
                            );
                          },
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    const SizedBox(width: 20),
                    Flexible(child: _buildSocialIcons(speaker)),
                  ],
                ),
                AppHtml(markup: bio),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Sessions', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 15),
                ...sessions.expand(
                  (session) => [
                    SessionExpansionTile(
                      session: session,
                      disableSpeakerTap: true,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcons(Speaker speaker) {
    var icons = <Widget>[];

    final xTwitterUrl = speaker.properties?.xTwitterUrl;

    if (xTwitterUrl != null) {
      icons.add(
        InkWell(
          onTap: () => launchUrl(xTwitterUrl),
          child: const FaIcon(
            FontAwesomeIcons.xTwitter,
            color: AppColors.accent,
            size: 35,
          ),
        ),
      );
    }

    final linkedInUrl = speaker.properties?.linkedInUrl;

    if (linkedInUrl != null) {
      icons.add(
        InkWell(
          onTap: () => launchUrl(linkedInUrl),
          child: const FaIcon(
            FontAwesomeIcons.linkedin,
            color: AppColors.accent,
            size: 35,
          ),
        ),
      );
    }

    final instagramUrl = speaker.properties?.instagramUrl;

    if (instagramUrl != null) {
      icons.add(
        InkWell(
          onTap: () => launchUrl(instagramUrl),
          child: const FaIcon(
            FontAwesomeIcons.instagram,
            color: AppColors.accent,
            size: 35,
          ),
        ),
      );
    }

    final websiteUrl = speaker.properties?.websiteUrl;

    if (websiteUrl != null) {
      icons.add(
        InkWell(
          onTap: () => launchUrl(websiteUrl),
          child: const FaIcon(
            FontAwesomeIcons.globe,
            color: AppColors.accent,
            size: 35,
          ),
        ),
      );
    }

    return Wrap(spacing: 30, runSpacing: 30, children: icons);
  }
}
