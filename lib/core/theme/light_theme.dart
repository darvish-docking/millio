import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';


final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
    outline: AppColors.textPrimary,
    onSurface: AppColors.background,
    error: Colors.red,
  ),

  scaffoldBackgroundColor: AppColors.background,

  // textTheme: const TextTheme(
  //   bodyMedium: TextStyle(color: AppColors.lightText),
  // ),
);