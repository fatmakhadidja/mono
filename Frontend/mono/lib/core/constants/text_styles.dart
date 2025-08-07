import 'package:flutter/material.dart';
import 'colors.dart'; // assuming AppColors is here

class AppTextStyles {
  // Headings
  static TextStyle heading1({Color color = AppColors.black}) =>
      TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: color);

  static TextStyle heading2({Color color = AppColors.black}) =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color);

  // Body text
  static TextStyle body1({Color color = AppColors.darkGrey}) =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: color);

  static TextStyle body2({Color color = AppColors.lightGrey}) =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color);

  // Caption / small text
  static TextStyle caption({Color color = AppColors.darkGrey}) =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  // Button
  static TextStyle button({Color color = AppColors.white}) => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: 0.5,
  );
}
