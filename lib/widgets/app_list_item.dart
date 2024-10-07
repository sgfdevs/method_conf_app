import 'dart:async';

import 'package:flutter/material.dart';

import 'package:method_conf_app/theme.dart';

class AppListItem extends StatelessWidget {
  final GestureTapCallback? onTap;
  final String text;

  const AppListItem({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap == null) {
          return;
        }

        Timer(const Duration(milliseconds: 100), () {
          onTap!();
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: AppColors.neutralLight),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.chevron_right, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
