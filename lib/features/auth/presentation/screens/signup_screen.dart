import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/signIn_screen.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signUpUser(BuildContext context) async {
  String username = usernameController.text.trim();
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String confirmPassword =
      confirmPasswordController.text.trim();


  /// Save to SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString("username", username);
  await prefs.setString("email", email);
  await prefs.setString("password", password);


// need to move to SIGN IN screen
   await prefs.setBool("isLoggedIn", true);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Signup Successful"),
    ),
  );

  /// Navigate to SignIn
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => HomeScreen(),
    ),
  );
}



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

                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Stack(
                  children: [
                    
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // const SizedBox(height: 30),

                  /// Image
                  Center(
                    child: Image.asset(
                      "assets/images/Logo2.png",
                      width: width * 0.1,
                      height: height * 0.05,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// Title
                  const Text(
                    "Create An Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                   SizedBox(height: height * 0.02),

                  /// Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.12),
                    child: const Text(
                      "Create a commitment-free profile to explore products",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat'),
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  Form(
  key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  child: Column(
    children: [

                  /// Username Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(
                            alpha: 0.1,
                          ), // shadow color
                          blurRadius: 10, // softness
                          spreadRadius: 1, // how much it spreads
                          offset: const Offset(0, 4), // position (x, y)
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        filled: true,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: "Montserrat", // 👈 your custom font
                          color: AppColors.backgroundSecondary,
                          fontWeight: FontWeight.w500,
                        ),
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Username is required";
                        }

                        if (value.trim().length < 3) {
                          return "Minimum 3 characters required";
                        }

                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                          return "Only letters, numbers, _ allowed";
                        }

                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(
                            alpha: 0.1,
                          ), // shadow color
                          blurRadius: 10, // softness
                          spreadRadius: 1, // how much it spreads
                          offset: const Offset(0, 4), // position (x, y)
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email Address",
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
                            "assets/images/Message.png",
                            width: width * 0.02,
                            height: width * 0.02,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value)) {
      return "Enter valid email";
    }

    return null;
  },
                    ),
                  ),

                  SizedBox(height: height * 0.015),
                  
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(
                            alpha: 0.1,
                          ), // shadow color
                          blurRadius: 10, // softness
                          spreadRadius: 1, // how much it spreads
                          offset: const Offset(0, 4), // position (x, y)
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller:passwordController,
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
                      validator: (value) {
    if (value == null || value.isEmpty) {
      return "Password required";
    }

    if (value.length < 8) {
      return "Minimum 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Need one uppercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Need one number";
    }

    return null;
  },
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  /// Password Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary.withValues(
                            alpha: 0.1,
                          ), // shadow color
                          blurRadius: 10, // softness
                          spreadRadius: 1, // how much it spreads
                          offset: const Offset(0, 4), // position (x, y)
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller:confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
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
                      validator: (value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }

    return null;
  },
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  /// Terms & Conditions
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
                            "I agree with the Terms of Services & Privacy Policy",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.015),

                  /// Sign up Button
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUpUser(context);
                        }
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
    ])),
                  SizedBox(height: height * 0.015),

                  /// 🔹 PILL BADGE (overlapping dark section)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Or Sign Up With",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.background,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.035),

                  /// 🔹 SOCIAL BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/images/apple.png', context),
                      _socialButton('assets/images/google.png', context),
                      _socialButton('assets/images/facebook.png', context),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
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
                            MaterialPageRoute(builder: (_) => SignInScreen()),
                          );
                        },
                        child: const Text(
                          "Sign In",
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
        SizedBox(width: width * 0.06),
        Container(
          width: width * 0.1,
          height: height * 0.1,
          decoration: const BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
