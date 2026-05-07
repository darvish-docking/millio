import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/forgot_password.dart';
import 'package:millio/features/auth/presentation/screens/signup_screen.dart';
import 'package:millio/core/common/main_layout.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInUser() async {
    String enteredUsername = _usernameController.text.trim();
    String enteredPassword = _passwordController.text.trim();

    if (enteredUsername.isEmpty || enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString("username");
    String? savedPassword = prefs.getString("password");

    if (enteredUsername == savedUsername && enteredPassword == savedPassword) {
      await prefs.setBool("isLoggedIn", true);
      
      // Refresh the provider data so ProfileScreen sees it
      if (!mounted) return;
      await context.read<OnboardingProvider>().loadUserData();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful!")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 BACKGROUND
          Column(
            children: [
              /// Top 3/4 Gradient → White
              SizedBox(
                height: height * 0.75,
                child: Stack(
                  children: [
                    /// 🔹 Top Horizontal Gradient (Green → Violet)
                    Container(
                      decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.primary, // Green (left)
                            AppColorsLegacy.secondary, // Violet (right)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),

                    /// 🔹 Fade to White (Vertical Overlay)
                    Container(
                      decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.transparent, Theme.of(context).scaffoldBackgroundColor,],
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
                    color: AppColorsLegacy.indigo.withValues(alpha: 0.85),
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
                              color: AppColorsLegacy.lightPurple.withOpacity(0.4),
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
              child: Column(
                children: [
                  /// Image
                  Image.asset(
                    "assets/images/noodles.png",
                    width: double.infinity,
                    height: height * 0.27,
                    fit: BoxFit.cover,
                  ),

                  SizedBox(height: height * 0.02),

                  /// Title
                   Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary
                    ),
                  ),

                  SizedBox(height: height * 0.001),

                  /// Subtitle
                   Text(
                    "Access to your account",
                    style: TextStyle(fontFamily: 'Montserrat',
                    color: colors.textPrimary),
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
                            color: AppColorsLegacy.textPrimary.withOpacity(
                              0.1,
                            ), // shadow color
                            blurRadius: 10, // softness
                            spreadRadius: 1, // how much it spreads
                            offset: const Offset(0, 4), // position (x, y)
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _usernameController,
                         style: TextStyle(
    color: colors.hintText, // 👈 typing text color
  
  ),
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle:  TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat", // 👈 your custom font
                            color: colors.hintText,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(
                              width * 0.02,
                            ), // control spacing
                            child: Image.asset(
                              "assets/images/username.png",
                              width: width * 0.02,
                              height: width * 0.02,
                              color: colors.hintText,
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
                            color: AppColorsLegacy.textPrimary.withOpacity(
                              0.1,
                            ), // shadow color
                            blurRadius: 10, // softness
                            spreadRadius: 1, // how much it spreads
                            offset: const Offset(0, 4), // position (x, y)
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(
    color: colors.hintText, // 👈 typing text color
  
  ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle:  TextStyle(
                            fontSize: 14,
                            fontFamily: "Montserrat", // 👈 your custom font
                            color: colors.hintText,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: colors.surface,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(
                              width * 0.02,
                            ), // control spacing
                            child: Image.asset(
                              "assets/images/Lock.png",
                              width: width * 0.02,
                              height: width * 0.02,
                              color: colors.hintText
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
                              activeColor: AppColorsLegacy.primary,
                              checkColor: AppColorsLegacy.background,
                            ),
                          ),
                           Text(
                            "Remember Me",
                            style: TextStyle(
                              color:colors.textPrimary,
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
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            color: colors.textPrimary,
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
                        onPressed: _signInUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsLegacy.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child:  Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppColorsLegacy.background,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  /// 🔹 PILL BADGE (overlapping dark section)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorsLegacy.indigo,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child:  Text(
                      "Or Sign In With",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColorsLegacy.background,
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
                          color: AppColorsLegacy.background,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child:  Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Montserrat',
                            color: AppColorsLegacy.primary, // 👈 green text
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

    return Row(
      children: [
        SizedBox(width: width * 0.05),
        Container(
          width: width * 0.1,
          height: width * 0.1,
          decoration:  BoxDecoration(
            color: AppColorsLegacy.background,
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
