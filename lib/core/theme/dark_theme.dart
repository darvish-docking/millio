import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
    outline: AppColors.background,
    onSurface: AppColors.backgroundTertiary,
    error: Colors.redAccent,
  ),

  scaffoldBackgroundColor: AppColors.textPrimary,

  // textTheme: const TextTheme(
  //   bodyMedium: TextStyle(color: AppColors.darkText),
  // ),
);