import 'package:flutter/material.dart';

class AppColors {
  static const primaryRed = Color(0xFFE31E2C);
  static const black = Color(0xFF000000);
  static const primaryGrey = Color(0xFFF2F3F2);
  static const secondaryGrey = Color(0xFF7C7C7C);
  static const tertiaryGrey = Colors.grey;
  static const background = Color(0xFFFFFFFF);

  static const heading = Color(0xFF7C7C7C);
  static const primary = Color(0xFF7C7C7C);
  static const grey = Color(0xFF7C7C7C);
  static const shape = Color(0xFF7C7C7C);
  static const body = Color(0xFF7C7C7C);
  static const input = Color(0xFF7C7C7C);

  static Color progression(double progress) {
    if (progress <= 0.25) {
      return Colors.orange;
    }

    if (progress > 0.25 && progress <= 0.50) {
      return Colors.yellowAccent.shade400;
    }

    if (progress > 0.50 && progress <= 0.75) {
      return Colors.yellowAccent.shade100;
    }

    if (progress >= 0.75 && progress <= 1.0) {
      return Colors.green.shade400;
    }

    if (progress > 1.0) {
      return Colors.red.shade400;
    }

    return Colors.grey;
  }
}
