import 'package:flutter/material.dart';
import 'package:method_conf_app/theme.dart';

class AppScreen extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget preHeader;
  final Widget postTitle;

  const AppScreen({
    Key key,
    @required this.body,
    @required this.title,
    this.preHeader,
    this.postTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[_buildHeader(context), Expanded(child: body)],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          ),
          preHeader ?? Container(),
          _buildBackButton(context),
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: AppColors.accent,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          postTitle ?? Container(),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container();
  }
}
