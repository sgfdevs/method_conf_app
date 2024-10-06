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
          'a': Style(
            textDecoration: TextDecoration.underline,
            color: AppColors.accent,
          )
        },
        onLinkTap: (url, _, __) {
          launchUrl(url!);
        },
      ),
    );
  }
}
