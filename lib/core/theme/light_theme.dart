import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: AppColors.light.primary,
    secondary: AppColors.light.secondary,
    surface: AppColors.light.surface,
    outline: AppColors.light.textPrimary,
    onSurface: AppColors.light.textPrimary,
    error: AppColors.light.error,
  ),

  scaffoldBackgroundColor: AppColors.light.scaffoldBackground,

  // textTheme: const TextTheme(
  //   bodyMedium: TextStyle(color: AppColors.light.textSecondary),
  // ),
);