import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class OnboardingScreenFour extends StatefulWidget {
  const OnboardingScreenFour({super.key});

  @override
  State<OnboardingScreenFour> createState() => _OnboardingScreenFourState();
}

class _OnboardingScreenFourState extends State<OnboardingScreenFour> {
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
                    child: Image.asset('assets/images/burger.png'),
                  ),
                
            
                const SizedBox(height: 40),
            
                // ✅ TITLE TEXT
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Choose The Quality Of Food Always",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 37,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: AppColors.background,
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
            
                const Spacer(),
            
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
                //                     // Navigator.push(
                //                     //   context,
                //                     //   MaterialPageRoute(builder: (_) => const OnboardingScreenThree()),
                //                     // );
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