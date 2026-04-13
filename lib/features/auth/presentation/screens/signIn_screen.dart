import 'dart:ui';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3AC569), // Green
                      Color(0xFF7B61FF), // Violet
                      Colors.white
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.1, 1.0],
                  ),
                ),
              ),

              /// Bottom 1/4 Dark Blur Section
              Stack(
                children: [
                  Container(
                    height: height * 0.25,
                    color: Colors.black.withOpacity(0.85),
                  ),

                  /// Glow effect at center
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 80,
                              spreadRadius: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Blur Layer
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: height * 0.25,
                      color: Colors.transparent,
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
                  const SizedBox(height: 30),

                  /// Image
                  Image.asset(
                    "assets/images/noodles.png",
                    // height: 120,
                  ),

                  const SizedBox(height: 20),

                  /// Title
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Subtitle
                  const Text(
                    "Access to your account",
                    style: TextStyle(
                      
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Username Field
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Username",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Password Field
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Remember + Forgot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (v) {}),
                          const Text("Remember me"),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?"),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF62C222),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Sign In"),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// 🔹 PILL BADGE (overlapping dark section)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Or Sign In With",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 SOCIAL BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _socialButton(Icons.apple),
                      _socialButton(Icons.g_mobiledata),
                      _socialButton(Icons.facebook),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 28),
    );
  }
}