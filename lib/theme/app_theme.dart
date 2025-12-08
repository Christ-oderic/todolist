import 'package:flutter/material.dart';
import 'package:todolist/theme/app_colors.dart';

import 'app_typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: TextTheme(bodyMedium: AppTypography.body),
  );
}
