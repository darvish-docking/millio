import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_main.dart';
import 'dart:math';

import 'package:millio/features/auth/presentation/screens/onboarding_screen_1.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  void _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingScreen(), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Stack(
        children: [

          /// 🔹 Background Image
          Positioned.fill(
  child: Stack(
    children: [

      /// 🔹 Base Gradient
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,        // 🔹 top-left
              // Color(0xFF6A00F4),   // violet
              AppColors.primary,   // green
              AppColors.background,        // 🔹 bottom-right
            ],
            stops: [
              0.2,   // white start
              // 0.35,  // violet appears
              0.65,  // green appears
              0.9,   // white end
            ],
          ),
        ),
      ),

      /// 🔹 Green Blur Circle (Top Right)
      Positioned(
        top: -height * 0.1,
        right: -width * 0.2,
        child: _blurCircle(
          size: width * 0.9,
          color: AppColors.primary.withValues(alpha:  0.3),
        ),
      ),

      /// 🔹 GREEN OVAL LINE
      Positioned(
  top: -height * 0.06,
  right: width * 0.18,
  child: eggOvalLine(
    width: width * 1.1,
    height: height * 0.26,
    color: AppColors.primary.withOpacity(0.4),
    angle: 310, // tweak slightly if needed
  ),
),


      /// 🔹 Violet Blur Circle (Bottom Left)
      Positioned(
        bottom: -height * 0.14,
        left: -width * 0.2,
        child: _blurCircle(
          size: width * 0.77,
          color: AppColors.purpleAccent.withValues(alpha:  0.3),
        ),
      ),

      /// 🔹 SECOND VIOLET CIRCLE (Bottom Left)
      Positioned(
        bottom: height * 0.12,
        left: -width * 0.2,
        child: _blurCircle(
          size: width * 0.5,
          color: AppColors.purple.withValues(alpha:  0.4),
        ),
      ),

      /// 🔹 VIOLET OVAL LINE
      Positioned(
        bottom: -height * 0.13,
        left: width * 0.05,
        child: eggOvalLine(
          width: width * 1.1,
          height: height * 0.26,
          color: AppColors.purple.withValues(alpha:  0.3),
          angle: -40,
        ),
      ),

      /// 🔹 Extra soft white overlay (optional for smoothness)
      Container(
        color: AppColors.background.withValues(alpha:  0.1),
      ),
    
      Positioned(
                    bottom: height * 0.04,
                    left: width * 0.3,
                    child: Text(
                      'Food & Beverage App',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: width * 0.045
                      ),
                    ),
                  ),
    ],
  ),
),

          /// 🔹 Dark Overlay (for better contrast)
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withValues(alpha:  0.1),
          //   ),
          // ),

          /// 🔹 Center Content
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [

                /// 🔸 Logo (from assets)
                Padding(
                  padding:  EdgeInsets.all(width * 0.045),
                  child: Image.asset(
                    "assets/images/Logo.png",
                    fit: BoxFit.contain,
                    color: AppColors.lightGreenAccent,
                    // width: width * 0.8,
                  ),
                ),


              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _blurCircle({required double size, required Color color}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}



Widget eggOvalLine({
  required double width,
  required double height,
  required Color color,
  double angle = 0, // in degrees
}) {
  return Transform.rotate(
    angle: angle * pi / 180, // convert to radians
    child: Transform.scale(
      scaleX: width / height,
      child: Container(
        width: height,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 1.2, // thin like Figma
          ),
        ),
      ),
    ),
  );
}