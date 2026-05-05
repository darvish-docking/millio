import 'package:flutter/material.dart';


class AppColors {
  // 🔹 Core Colors (Instance Fields)
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color secondary;
  final Color background;
  final Color scaffoldBackground;
  final Color surface;
  final Color textField;

  
  // 🔹 Text Colors
  final Color hintText;
  final Color textPrimary;
  final Color textSecondary;
  final Color textWhite;
  final Color textHint;
  
  // 🔹 Functional Colors
  final Color error;
  final Color success;
  final Color warning;
  final Color info;
  
  // 🔹 Border & Divider
  final Color border;
  final Color divider;
  final Color boxShadow;

  // 🔹 Specific UI Colors
  final Color inputFill;
  final Color cardBackground;
  final Color homeBanner;

  const AppColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.secondary,
    required this.background,
    required this.scaffoldBackground,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textWhite,
    required this.textHint,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.border,
    required this.divider,
    required this.boxShadow,
    required this.inputFill,
    required this.cardBackground,
    required this.homeBanner, 
    required this.hintText,
    required this.textField
  });

  static const AppColors light = AppColors(
    primary: Color(0xFF62C222),
    primaryLight: Color(0xFFEFF9E9),
    primaryDark: Color(0xFF388E3C),
    secondary: Color(0xFF7E57C2),
    background: Colors.white,
    scaffoldBackground: Color(0xFFF8F9FB),
    surface: Colors.white,
    textField: Colors.white,
    hintText: Color(0xff999999),
    textPrimary: Colors.black,
    textSecondary: Color(0xFF7A7A7A),
    textWhite: Colors.white,
    textHint: Colors.black26,
    error: Color(0xFFF44336),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFFC107),
    info: Colors.blue,
    border: Color(0xFFE0E0E0),
    divider: Color(0xFFBDBDBD),
    boxShadow: Colors.black12,
    inputFill: Color(0xFFF5F5F5),
    cardBackground: Colors.white,
    homeBanner: Color.fromARGB(255, 121, 39, 176),
  );

  static const AppColors dark = AppColors(
    primary: Color(0xFF62C222),
    primaryLight: Color(0xFF2E3D24),
    primaryDark: Color(0xFF388E3C),
    secondary: Color(0xFF9575CD),
    background: Color(0xFF121212),
    scaffoldBackground: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    textField: Color(0xff333333),
    hintText: Colors.white,
    textPrimary: Colors.white,
    textSecondary: Color(0xFFB0B0B0),
    textWhite: Colors.white,
    textHint: Colors.white30,
    error: Color(0xFFEF5350),
    success: Color(0xFF81C784),
    warning: Color(0xFFFFD54F),
    info: Colors.blueAccent,
    border: Color(0xFF333333),
    divider: Color(0xFF424242),
    boxShadow: Colors.black54,
    inputFill: Color(0xFF2C2C2C),
    cardBackground: Color(0xFF1E1E1E),
    homeBanner: Color.fromARGB(255, 121, 39, 176),
  );

  // Categories (keeping as constants for now as they are often decorative)
  static const Color category1 = Color(0xff9EFC61);
  static const Color category2 = Color(0xffFCEC61);
  static const Color category3 = Color(0xff61E0FC);
  static const Color category4 = Color(0xffCA61FC);
  static const Color category5 = Color(0xffFC6161);
  static const Color category6 = Color(0xff61FCB1);
  static const Color category7 = Color(0xff6170FC);
  static const Color category8 = Color(0xffFC8F61);
  static const Color transparent = Colors.transparent;

  // 🔹 Reference/Legacy Colors (Restored as requested)
  /*
  static const Color primaryLegacy = Color(0xFF62C222);
  static const Color secondaryLegacy = Color(0xFF7E57C2);
  static const Color indigo = Color.fromARGB(255, 12, 3, 32);
  static const Color lightPurple = Color.fromARGB(255, 231, 222, 236);
  static const Color purpleAccent = Colors.purpleAccent;
  static const Color purple = Colors.purple;
  static const Color lightGreenAccent = Colors.lightGreenAccent;
  static const Color backgroundTertiary = Color(0xFF333333);
  static const Color inputBorderLegacy = Color(0xFFDADADA);
  static const Color inputFocused = Color(0xFFFF7A00);
  static const Color amber = Colors.amber;
  static const Color primaryLight05 = Color(0xFFE8F5E9); // green.shade50
  static const Color textWhite30 = Colors.white30;
  static const Color textWhite60 = Colors.white60;
  static const Color textWhite24 = Colors.white24;
  static const Color buttonFavourites = Colors.red;
  */
}

/// 🔹 Legacy Compatibility (for gradual migration)
class AppColorsLegacy {
  static Color get primary => AppColors.light.primary;
  static Color get primaryLight => AppColors.light.primaryLight;
  static Color get primaryDark => AppColors.light.primaryDark;
  static Color get secondary => AppColors.light.secondary;
  static Color get background => AppColors.light.background;
  static Color get scaffoldBackground => AppColors.light.scaffoldBackground;
  static Color get textPrimary => AppColors.light.textPrimary;
  static Color get textSecondary => AppColors.light.textSecondary;
  static Color get textWhite => AppColors.light.textWhite;

   static const Color indigo = Color.fromARGB(255, 12, 3, 32);
  static const Color lightPurple = Color.fromARGB(255, 231, 222, 236);
  static const Color purpleAccent = Colors.purpleAccent;
  static const Color purple = Colors.purple;
  static const Color lightGreenAccent = Colors.lightGreenAccent;
  static const Color textWhite30 = Colors.white30;
  static const Color textWhite60 = Colors.white60;
  static const Color textWhite24 = Colors.white24;

  static Color get error => AppColors.light.error;
  static Color get success => AppColors.light.success;
  static Color get warning => AppColors.light.warning;
  static Color get border => AppColors.light.border;
  static Color get divider => AppColors.light.divider;
  static Color get boxShadow => AppColors.light.boxShadow;
  static Color get inputFill => AppColors.light.inputFill;
  static Color get home => AppColors.light.homeBanner;
  static Color get transparent => Colors.transparent;
  static Color get backgroundSecondary => Colors.grey;
  static Color get backgroundSecondary1 => Colors.grey.shade100;
  static Color get backgroundSecondary2 => Colors.grey.shade200;
  static Color get backgroundSecondary3 => Colors.grey.shade300;
  static Color get backgroundSecondary4 => Colors.grey.shade400;
  static Color get backgroundSecondary5 => Colors.grey.shade500;
  static Color get backgroundSecondary6 => Colors.grey.shade600;
  static Color get backgroundSecondary7 => Colors.grey.shade700;
  static Color get textPrimarylight12 => Colors.black12;
  static Color get textPrimarylight87 => Colors.black87;
  static Color get textPrimarylight26 => Colors.black26;
  static Color get background07 => Colors.white70;
  static Color get amber => Colors.amber;
  static Color get buttonFavourites => Colors.red;
  static Color get inputBorder => const Color(0xFFDADADA);
}

extension AppColorExtension on BuildContext {
  AppColors get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
  }
}