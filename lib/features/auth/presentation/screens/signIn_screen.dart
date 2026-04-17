import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/forgot_password.dart';
import 'package:millio/features/auth/presentation/screens/otp_screen.dart';
import 'package:millio/features/auth/presentation/screens/signup_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 BACKGROUND
          Column(
            children: [
              /// Top 3/4 Gradient → White
              Container(
                height: height * 0.75,
                child: Stack(
                  children: [
                    /// 🔹 Top Horizontal Gradient (Green → Violet)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary, // Green (left)
                            AppColors.secondary, // Violet (right)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),

                    /// 🔹 Fade to White (Vertical Overlay)
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.transparent, AppColors.background],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.25, 0.7], // controls fade depth
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Bottom 1/4 Dark Blur Section
              Stack(
                children: [
                  Container(
                    height: height * 0.25,
                    color: AppColors.indigo.withValues(alpha: 0.85),
                  ),

                  /// Glow effect at center
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: width * 0.5,
                        height: height * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.lightPurple.withOpacity(0.4),
                              blurRadius: 80,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Blur Layer
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      height: height * 0.25,
                      color: AppColors.transparent,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// 🔹 FOREGROUND CONTENT
          SafeArea(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.symmetric(horizontal: with),
              child: Column(
                children: [
                  // const SizedBox(height: 30),

                  /// Image
                  Image.asset(
                    "assets/images/noodles.png",
                    width: double.infinity,
                    height: height * 0.27,
                    fit: BoxFit.cover,
                  ),

                  SizedBox(height: height * 0.02),

                  /// Title
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: height * 0.001),

                  /// Subtitle
                  const Text(
                    "Access to your account",
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),

                  SizedBox(height: height * 0.02),

                  /// Username Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withOpacity(
                              0.1,
                            ), // shadow color
                            blurRadius: 10, // softness
                            spreadRadius: 1, // how much it spreads
                            offset: const Offset(0, 4), // position (x, y)
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat", // 👈 your custom font
                            color: AppColors.backgroundSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(
                              width * 0.02,
                            ), // control spacing
                            child: Image.asset(
                              "assets/images/username.png",
                              width: width * 0.02,
                              height: width * 0.02,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  /// Password Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withOpacity(
                              0.1,
                            ), // shadow color
                            blurRadius: 10, // softness
                            spreadRadius: 1, // how much it spreads
                            offset: const Offset(0, 4), // position (x, y)
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat", // 👈 your custom font
                            color: AppColors.backgroundSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(
                              width * 0.02,
                            ), // control spacing
                            child: Image.asset(
                              "assets/images/Lock.png",
                              width: width * 0.02,
                              height: width * 0.02,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  /// Remember + Forgot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.85,
                            child: Checkbox(
                              value: true,
                              onChanged: (v) {},
                              activeColor: AppColors.primary,
                              checkColor: AppColors.background,
                            ),
                          ),
                          const Text(
                            "Remember Me",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  /// Sign In Button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SizedBox(
                      width: double.infinity,
                      height: height * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OtpScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppColors.background,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  /// 🔹 PILL BADGE (overlapping dark section)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.indigo,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Or Sign In With",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.background,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  /// 🔹 SOCIAL BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/images/apple.png', context),
                      _socialButton('assets/images/google.png', context),
                      _socialButton('assets/images/facebook.png', context),
                    ],
                  ),

                  SizedBox(height: height * 0.04),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: AppColors.background,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Montserrat',
                            color: AppColors.primary, // 👈 green text
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(String imagePath, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        SizedBox(width: width * 0.05),
        Container(
          width: width * 0.1,
          height: width * 0.1,
          decoration: const BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
