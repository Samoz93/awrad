import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppThemes {
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
  static const buttonTextStyle =
      TextStyle(fontSize: 30, color: Colors.white, fontFamily: "gg");
}

class AppColors {
  static final mainColor = Color(0xffD88E65);
  static final mainColorSelected = Color(0xff994D23);
}
