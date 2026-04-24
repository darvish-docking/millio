import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_1.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_2.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_3.dart';
import 'package:millio/features/auth/presentation/screens/onboarding_screen_4.dart';
import 'package:millio/features/auth/presentation/screens/signIn_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final h = size.height;
    final w = size.width;

    return Scaffold(
      body: Stack(
        children: [

          // ✅ PAGE VIEW (FULL SCREEN BACKGROUNDS)
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              context.read<OnboardingProvider>().updateIndex(index);
            },
            children: const [
              OnboardingScreenOne(),
              OnboardingScreenTwo(),
              OnboardingScreenThree(),
              OnboardingScreenFour(),
            ],
          ),

          // ✅ BOTTOM CONTROLS (FLOATING OVER UI)
          Positioned(
            bottom: h * 0.06,
            left: 0,
            right: 0,
            child: Column(
              children: [

                // 🔵 INDICATOR
                Consumer<OnboardingProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                          width: provider.currentIndex == index ? w * 0.05 : w * 0.015,
                          height: w * 0.015,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: h * 0.05),

                // 🔘 TOGGLE BUTTON
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Container(
                    padding: EdgeInsets.all(w * 0.015),
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(w * 0.1),
                    ),
                    child: Row(
                      children: [

                        // SKIP
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(), 
                            ),
                          );
                            },
                            child: Center(
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                  color: AppColors.background,
                                  fontSize: w * 0.038,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        ),

                        // NEXT (GLOW BUTTON)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final provider =
                                  context.read<OnboardingProvider>();

                              if (provider.currentIndex < 3) {
                                _controller.nextPage(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                // Navigate to Sign In
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(), 
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.symmetric(vertical: h * 0.015),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(w * 0.08),

                                // ✨ GLOW EFFECT
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.boxShadow,
                                    blurRadius: w * 0.05,
                                    spreadRadius: w * 0.005,
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: w * 0.038,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
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