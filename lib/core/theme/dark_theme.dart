import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: AppColors.dark.primary,
    secondary: AppColors.dark.secondary,
    surface: AppColors.dark.surface,
    outline: AppColors.dark.border,
    onSurface: AppColors.dark.textPrimary,
    error: AppColors.dark.error,
  ),

  scaffoldBackgroundColor: AppColors.dark.scaffoldBackground,

  // textTheme: const TextTheme(
  //   bodyMedium: TextStyle(color: AppColors.dark.textSecondary),
  // ),
);