import 'package:flutter/material.dart';


class AppFontWeight {
  static FontWeight extraLight = FontWeight.w100;
  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w900;
}

class AppFontSize {
  static const double font_8 = 8;
  static const double font_10 = 10;
  static const double font_12 = 12;
  static const double font_14 = 14;
  static const double font_16 = 16;
  static const double font_18 = 18;
  static const double font_20 = 20;
  static const double font_22 = 22;
  static const double font_24 = 24;
  static const double font_26 = 26;
  static const double font_28 = 28;
  static const double font_34 = 34;
  static const double font_36 = 36;
}


class AppTextStyles {

  static TextStyle extraLightStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.extraLight);
  }

  static TextStyle lightStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.light);
  }

  static TextStyle regularStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.regular);
  }

  static TextStyle mediumStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.medium);
  }

  static TextStyle boldStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.bold);
  }

  static TextStyle extraBoldStyle(double size, Color color) {
    return TextStyle(
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.extraBold);
  }


  static TextStyle mediumDecorationStyle(decoration, double size, Color color) {
    return TextStyle(
        decoration: decoration,
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.medium);
  }

  static TextStyle boldDecorationStyle(decoration,double size, Color color) {
    return TextStyle(
        decoration: decoration,
        fontSize: size, color: color, fontFamily: "Roboto", fontWeight: AppFontWeight.bold);
  }

}