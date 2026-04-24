import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_2.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
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
                Image.asset(
                  'assets/images/second-logo.png',
                  height: height * 0.05,
                  fit: BoxFit.contain,
                ),
            
            
                // ✅ PLACEHOLDER IMAGE
                Image.asset('assets/images/french-fries.png',
                width: width ,
                height: height * 0.5,
                fit: BoxFit.cover,),
                
            
                // ✅ TITLE TEXT
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                  child: Text(
                    "The Taste That Rhymes With Your Cravings",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.075,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: AppColors.background,
                    ),
                  ),
                ),
            
                 SizedBox(height: height * 0.1),
            
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}