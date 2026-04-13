import 'package:flutter/material.dart';
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
            bottom: 50,
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
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: provider.currentIndex == index ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                // 🔘 TOGGLE BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
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
                            child: const Center(
                              child: Text(
                                "Skip",
                                style: TextStyle(color: Colors.white),
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
                                // TODO: Navigate to Home/Login
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),

                                // ✨ GLOW EFFECT
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white70,
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
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