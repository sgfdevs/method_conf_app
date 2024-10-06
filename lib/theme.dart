import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const accent = Color(0xffd72f32);
  static const primaryDark = Color(0xff151515);
  static const primary = Color(0xff232323);
  static const primaryLight = Color(0xff484848);
  static const neutral = Color(0xff979797);
  static const neutralMidLight = Color(0xffb7b7b7);
  static const neutralLight = Color(0xffd8d8d8);
  static const neutralExtraLight = Color(0xfff3f3f3);
  static const twitterPrimary = Color(0xff1da1F2);
}

ThemeData appTheme(BuildContext context) {
  final theme = Theme.of(context);

  return theme.copyWith(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    colorScheme: theme.colorScheme.copyWith(secondary: AppColors.accent),
    textTheme: GoogleFonts.sourceSans3TextTheme(),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}
