import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_4.dart';

class OnboardingScreenThree extends StatefulWidget {
  const OnboardingScreenThree({super.key});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary, // green
              Theme.of(context).colorScheme.secondary, // purple // purple
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
            
                SizedBox(height: height * 0.02),
            
                // ✅ PLACEHOLDER IMAGE
                Center(
                    child: Image.asset(
                      'assets/images/sandwich.png',
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
                    "Making Dishes Wonderful Again And Again",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.085,
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