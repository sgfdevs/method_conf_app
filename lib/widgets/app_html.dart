import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';

class AppHtml extends StatelessWidget {
  final String? markup;

  const AppHtml({super.key, this.markup});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(fontSize: 14, height: 1.6),
      child: Html(
        data: markup,
        style: {
          'body': Style(color: Colors.black, margin: Margins.all(0)),
          'a': Style(
            textDecoration: TextDecoration.underline,
            color: AppColors.accent,
          ),
          'li': Style(color: Colors.black, padding: HtmlPaddings.all(0)),
          'ol': Style(
            padding: HtmlPaddings.symmetric(horizontal: 15, vertical: 0),
          ),
          'ul': Style(
            padding: HtmlPaddings.symmetric(horizontal: 15, vertical: 0),
          ),
        },
        onLinkTap: (url, _, __) {
          if (url != null) {
            launchUrl(url);
          }
        },
      ),
    );
  }
}
