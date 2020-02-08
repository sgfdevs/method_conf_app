import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';

class AppHtml extends StatelessWidget {
  final String markup;

  const AppHtml({Key key, this.markup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: markup,
      defaultTextStyle: TextStyle(fontSize: 14, height: 1.6),
      linkStyle: TextStyle(
        decoration: TextDecoration.underline,
        color: AppColors.accent,
      ),
      onLinkTap: (url) {
        launchUrl(url);
      },
    );
  }
}
