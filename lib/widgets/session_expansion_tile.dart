import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:method_conf_app/models/session.dart';
import 'package:method_conf_app/models/speaker.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';
import 'package:method_conf_app/widgets/app_html.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';

class SessionExpansionTile extends StatelessWidget {
  final Session session;
  final bool disableSpeakerTap;

  const SessionExpansionTile({
    Key key,
    this.session,
    this.disableSpeakerTap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutralExtraLight,
      padding: EdgeInsets.all(10),
      child: ConfigurableExpansionTile(
        header: _buildHeader(expanded: false),
        headerExpanded: _buildHeader(expanded: true),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 15),
            child: AppHtml(markup: session.description ?? 'Coming Soon'),
          )
        ],
      ),
    );
  }

  Widget _buildHeader({bool expanded}) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  session.time,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Visibility(
                visible: false,
                child: FlatButton(
                  color: AppColors.accent,
                  child: Text(
                    'Session Feedback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  session.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    expanded ? 'Less' : 'More',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Icon(expanded ? Icons.expand_less : Icons.expand_more),
                ],
              )
            ],
          ),
          SizedBox(height: 8),
          _buildSpeaker(),
        ],
      ),
    );
  }

  Widget _buildSpeaker() {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: _speakerTapped,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: session.speaker.image,
              placeholder: (context, url) => Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.transparent),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _speakerTapped,
                child: Text(
                  session.speaker.name,
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      session.speaker.title,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _speakerTapped() {
    if (this.disableSpeakerTap) {
      return;
    }

    AppNavigator.pushNamed(
      '/more/speakers/detail',
      arguments: session.speaker,
    );
  }
}
