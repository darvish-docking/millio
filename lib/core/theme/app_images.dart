import 'package:flutter/material.dart';

class AppImages {

  static String profile_bg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? 'assets/images/dark/profile-bg.png'
        : 'assets/images/profile-bg.png';
  }
}