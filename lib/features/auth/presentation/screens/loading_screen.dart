import 'package:flutter/material.dart';
import 'dart:math';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// 🔹 Background Image
          Positioned.fill(
  child: Stack(
    children: [

      /// 🔹 Base Gradient
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,        // 🔹 top-left
              // Color(0xFF6A00F4),   // violet
              Color(0xFF62C222),   // green
              Colors.white,        // 🔹 bottom-right
            ],
            stops: [
              0.2,   // white start
              // 0.35,  // violet appears
              0.65,  // green appears
              0.9,   // white end
            ],
          ),
        ),
      ),

      /// 🔹 Green Blur Circle (Top Right)
      Positioned(
        top: -80,
        right: -80,
        child: _blurCircle(
          size: 350,
          color: Color(0xFF62C222).withValues(alpha:  0.3),
        ),
      ),

      /// 🔹 GREEN OVAL LINE
      Positioned(
  top: -50,
  right: 70,
  child: eggOvalLine(
    width: 440,
    height: 220,
    color: Colors.green.withOpacity(0.4),
    angle: 310, // tweak slightly if needed
  ),
),


      /// 🔹 Violet Blur Circle (Bottom Left)
      Positioned(
        bottom: -120,
        left: -80,
        child: _blurCircle(
          size: 300,
          color: Colors.purpleAccent.withValues(alpha:  0.3),
        ),
      ),

      /// 🔹 SECOND VIOLET CIRCLE (Bottom Left)
      Positioned(
        bottom: 100,
        left: -80,
        child: _blurCircle(
          size: 200,
          color: Colors.purple.withValues(alpha:  0.4),
        ),
      ),

      /// 🔹 VIOLET OVAL LINE
      Positioned(
        bottom: -110,
        left: 20,
        child: eggOvalLine(
          width: 440,
          height: 220,
          color: Colors.purple.withValues(alpha:  0.3),
          angle: -40,
        ),
      ),

      /// 🔹 Extra soft white overlay (optional for smoothness)
      Container(
        color: Colors.white.withValues(alpha:  0.1),
      ),
    
      Positioned(
                    bottom: 30,
                    left: 120,
                    child: Text(
                      'Food & Beverage App',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18
                      ),
                    ),
                  ),
    ],
  ),
),

          /// 🔹 Dark Overlay (for better contrast)
          // Positioned.fill(
          //   child: Container(
          //     color: Colors.black.withValues(alpha:  0.1),
          //   ),
          // ),

          /// 🔹 Center Content
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [

                /// 🔸 Logo (from assets)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/Logo.png",
                    fit: BoxFit.contain,
                    color: Colors.lightGreenAccent,
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

Widget _blurCircle({required double size, required Color color}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
  );
}



Widget eggOvalLine({
  required double width,
  required double height,
  required Color color,
  double angle = 0, // in degrees
}) {
  return Transform.rotate(
    angle: angle * pi / 180, // convert to radians
    child: Transform.scale(
      scaleX: width / height,
      child: Container(
        width: height,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color,
            width: 1.2, // thin like Figma
          ),
        ),
      ),
    ),
  );
}