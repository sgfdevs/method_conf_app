import 'package:flutter/material.dart';

import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/widgets/app_navigator.dart';

var buildBackButtonCalled = 0;

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
      children: <Widget>[
        _buildHeader(context),
        Expanded(
          child: Container(
            color: Colors.white,
            child: SizedBox(width: double.infinity ,child: body),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.primaryDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 40,
            ),
          ),
          preHeader ?? Container(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBackButton(context),
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          postTitle ?? Container(),
          Padding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    var currentRouteName = ModalRoute.of(context).settings.name;

    return Visibility(
      visible: _isNestedRoute(currentRouteName),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      maintainInteractivity: false,
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Icon(Icons.chevron_left, color: Colors.white),
            Text('Back', style: TextStyle(color: Colors.white)),
          ],
        ),
        onTap: () {
          AppNavigator.pop();
        },
      ),
    );
  }

  bool _isNestedRoute(String routeName) {
    var segments = routeName.split('/').where((s) => s != '');
    return segments.length >= 2;
  }
}
