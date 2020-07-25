import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static const timerTextStyle = TextStyle(fontSize: 30);
  static const azanTimeTextStyle = TextStyle(fontSize: 20);

  static const linearTitle = LinearGradient(
      colors: [Colors.transparent, Colors.white],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static final linearPointer = LinearGradient(
      colors: [AppColors.mainColor, AppColors.mainColorSelected],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static final linearPointerTers = LinearGradient(
      colors: [AppColors.mainColor, AppColors.mainColorSelected],
      transform: GradientRotation(1),
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static const titleTextStyle = TextStyle(fontSize: 40);
  static final pageTitleStyle =
      TextStyle(fontSize: 30, color: AppColors.addColor);
  static const buttonTextStyle =
      TextStyle(fontSize: 30, color: Colors.white, fontFamily: "gg");
}

class AppColors {
  static final mainColor = Color(0xffD88E65);
  static final mainColorSelected = Color(0xff994D23);
  static final deleteColor = Color(0xffe63946);
  static final addColor = Color(0xff4ecdc4);

  static final adanNormal = Color(0xffD5C0B4);
  static final adanActive = Color(0xffDAD222);
  static final adanNotificationCircle = Color(0xffD88E65);
  // static final adanNotificationPill = Color(0xffD88E65);
}
