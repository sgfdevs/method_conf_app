import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const accent = Color(0xffd72f32);
  static const primaryDark = Color(0xff151515);
  static const primary = Color(0xff232323);
  static const neutral = Color(0xff979797);
  static const neutralMidLight = Color(0xffb7b7b7);
  static const neutralLight = Color(0xfff3f3f3);
  static const twitterPrimary = Color(0xff1da1F2);
}



ThemeData appTheme(BuildContext context) {
  return Theme.of(context).copyWith(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    textTheme: GoogleFonts.sourceSansProTextTheme(),
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}
