import 'package:flutter/material.dart';
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
              Color(0xFF7E57C2),
              Color(0xFF8BC34A), // green
              Color(0xFF7E57C2), // purple
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding:  EdgeInsets.zero,
            child: Column(
              children: [
            
                const SizedBox(height: 20),
            
                // ✅ LOGO / TITLE
                Column(
                  children:  [
                    Image.asset('assets/images/second-logo.png')
                  ],
                ),
            
                const SizedBox(height: 20),
            
                // ✅ PLACEHOLDER IMAGE
                Center(
                    child: Image.asset('assets/images/sandwich.png'),
                  ),
                
            
                const SizedBox(height: 40),
            
                // ✅ TITLE TEXT
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Making Dishes Wonderful Again And Again",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
            
                const SizedBox(height: 10),
            
                // ✅ DOT INDICATOR
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List.generate(
                //     4,
                //     (index) => Container(
                //       margin: const EdgeInsets.symmetric(horizontal: 4),
                //       width: index == 0 ? 14 : 6,
                //       height: 6,
                //       decoration: BoxDecoration(
                //         color: index == 0 ? Colors.white : Colors.white54,
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //   ),
                // ),
            
                // const Spacer(),
            
                // ✅ BOTTOM TOGGLE BUTTON
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Container(
                //     padding: const EdgeInsets.all(6),
                //     decoration: BoxDecoration(
                //       color: Colors.white.withOpacity(0.2),
                //       borderRadius: BorderRadius.circular(40),
                //     ),
                //     child: Row(
                //       children: [
            
                //         // Skip
                //         Expanded(
                //           child: Center(
                //             child: Text(
                //               "Skip",
                //               style: TextStyle(
                //                 color: Colors.white.withOpacity(0.8),
                //               ),
                //             ),
                //           ),
                //         ),
            
                //         // Toggle Button
                //         Expanded(
                //           child: GestureDetector(
                //             onTap: () {
                //               setState(() {
                //                 isNextSelected = !isNextSelected;
                //               });
                //             },
                //             child: AnimatedContainer(
                //               duration: const Duration(milliseconds: 300),
                //               padding: const EdgeInsets.symmetric(vertical: 12),
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(30),
            
                //                 // ✅ GLOW EFFECT
                //                 color: Colors.white,
                //                 boxShadow: [
                //                   if (isNextSelected)
                //                     const BoxShadow(
                //                       color: Colors.white70,
                //                       blurRadius: 20,
                //                       spreadRadius: 2,
                //                     ),
                //                 ],
                //               ),
                //               child: Center(
                //                 child: TextButton(
                //                   onPressed: () {
                //                     Navigator.push(
                //                       context,
                //                       MaterialPageRoute(builder: (_) => const OnboardingScreenFour()),
                //                     );
                //                   },
                //                   style: TextButton.styleFrom(
                //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // reduce height
                //                       minimumSize: Size.zero, // removes default min height
                //                       tapTargetSize: MaterialTapTargetSize.shrinkWrap, // tighter layout
                //                     ),
                //                   child: Text(
                //                     "Next",
                //                     style: TextStyle(
                //                       color: Colors.green.shade700,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                 )
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}