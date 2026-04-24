import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_3.dart';

class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  bool isNextSelected = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ✅ BACKGROUND GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.secondary,
              AppColors.primary, // green
              AppColors.secondary, // purple
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding:  EdgeInsets.zero,
            child: Column(
              children: [
            
                SizedBox(height: height * 0.02),
            
                // ✅ LOGO / TITLE
                Column(
                  children:  [
                    Image.asset(
                      'assets/images/second-logo.png',
                      height: height * 0.05,
                      fit: BoxFit.contain,
                    )
                  ],
                ),
            
                SizedBox(height: height * 0.04),
            
                // ✅ PLACEHOLDER IMAGE
                Center(
                    child: Image.asset(
                      'assets/images/coffee.png',
                      height: height * 0.45,
                      width: width * 0.9,
                      fit: BoxFit.contain,
                    ),
                  ),
                
            
                SizedBox(height: height * 0.04),
            
                // ✅ TITLE TEXT
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    "A Rhythmic Pattern Of Food And Taste",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.09,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: AppColors.background,
                    ),
                  ),
                ),
            
                SizedBox(height: height * 0.01),
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}