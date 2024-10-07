import 'package:flutter/material.dart';

import 'package:method_conf_app/widgets/app_screen.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: 'Not Found',
      body: const Text('Not Found'),
    );
  }
}
