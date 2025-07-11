import 'package:flutter/material.dart';
import 'app_colors.dart';

class Styles {
  static const TextStyle appBarTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.green500,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  // ---- MODERN METRIC CARD TEXT STYLES ----
  static const TextStyle metricTitleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.gray500,
    letterSpacing: 0.2,
  );

  static const TextStyle metricValueStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.green500, // You can override this per metric
    letterSpacing: -0.5,
  );
  // ----------------------------------------

  static const TextStyle profileLabelStyle = TextStyle(
    fontSize: 13,
    color: AppColors.gray500,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle profileValueStyle = TextStyle(
    fontSize: 15,
    color: AppColors.green500,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle modalTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle drawerItemStyle = TextStyle(
    fontSize: 15,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
  );
}
