import 'package:flutter/material.dart';

import 'package:method_conf_app/theme.dart';

class AppListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;

  const AppListItem({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: AppColors.neutralLight),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.chevron_right, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
