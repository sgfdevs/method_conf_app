import 'package:flutter/material.dart';
import 'package:method_conf_app/theme.dart';
import 'package:method_conf_app/utils/utils.dart';

class AppBanner extends StatelessWidget {
  final String text;
  final String buttonText;
  final GestureTapCallback onButtonPress;

  const AppBanner({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              color: AppColors.accent,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                heightFactor: 2,
                widthFactor: 2,
                child: FractionalTranslation(
                  translation: const Offset(-0.31, -0.31),
                  child: Transform.rotate(
                    angle: degreesToRads(-40),
                    child: Container(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 45),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/method_logo.png', height: 40),
                  const SizedBox(height: 20),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        backgroundColor: Colors.black),
                    onPressed: onButtonPress,
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
