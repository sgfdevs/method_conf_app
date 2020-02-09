import 'package:flutter/material.dart';

import 'package:method_conf_app/theme.dart';

class HalfBorderBox extends StatelessWidget {
  final Widget child;

  const HalfBorderBox({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 3, right: 3, bottom: 3),
          child: child,
        ),
      ],
    );
  }
}
