import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF193416);
  static const Color secondary = Colors.green;
  static const Color white = Color(0xFFFFFFFF); // Light Grey
  static const Color background = Color(0xFFE8F5E9); // Light Grey
  static const Color textPrimary = Color(0xFF000000); // Black
  static const Color textSecondary = Colors.black54; // Grey

  static const Color stress = Color(0xFF2E5266);
  static const Color happiness = Color(0xFFFF6B6B);
  static const Color calmness = Color(0xFF4A7C59);
  static const Color energy = Color(0xFF6EC6CA);

}

List<Color> progressStrokeColor = const [
  Color(0xffFF7A01),
  Color(0xffFF0069),
  Color(0xff7639FB),
  Color(0xffFF7A01),
];

List<Color> progressBackgroundColor = [
  const Color(0xffFF7A01).withOpacity(0.6),
  const Color(0xffFF0069).withOpacity(0.6),
  const Color(0xff7639FB).withOpacity(0.6),
  const Color(0xffFF7A01).withOpacity(0.6),
];

