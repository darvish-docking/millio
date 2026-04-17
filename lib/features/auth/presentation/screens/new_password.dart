import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
      children: [

        /// 🔽 Bottom Image (ALWAYS fills bottom)
        Positioned(
  bottom: 0,
  left: 0,
  right: 0,
  child: SizedBox(
    width: double.infinity,
    child: Stack(
      children: [

        
        /// Gradient Overlay 1
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1, -0.3),
                end: Alignment(1, 0.3),
                colors: [
                  Color.fromRGBO(150, 37, 255, 0.18),
                  Color.fromRGBO(150, 37, 255, 0.49),
                  Color.fromRGBO(105, 194, 34, 0.60),
                  Color.fromRGBO(98, 194, 34, 0.92),
                ],
                stops: [0.01, 0.25, 0.65, 1.0],
              ),
            ),
          ),
        ),

        /// Gradient Overlay 2 (white fade top to transparent)
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.transparent,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        /// Background Image
        Image.asset(
          "assets/images/forgotPassword-Background.png",
          fit: BoxFit.fitWidth,
          width: double.infinity,
        ),

        /// 4️⃣ Foreground Main Image (if any)
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            "assets/images/sky.png",
            fit: BoxFit.fill,
            width: 400,
            height: 400,
          ),
        ),


      ],
    ),
  ),
),

        /// 🔼 Top Content
        Padding(
          padding: EdgeInsets.zero,
                child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                
          /// 🔙 Back Button
          Padding(
            padding:  EdgeInsets.only(left: width * 0.05),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.10,
                height: MediaQuery.of(context).size.width * 0.10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textPrimary.withOpacity(0.05), // faded background
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/left-arrow.png",
                    width: MediaQuery.of(context).size.width * 0.05,
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
            ),
          ),
                
          SizedBox(height: height * 0.03),
                
          /// 🧾 Heading
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Text(
                "Set New Password",
                style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'
                ),
              ),
            ),
          ),
                
          SizedBox(height: height * 0.01),
                
          /// 🧾 Subheading
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Text(
                "Set A New Password That Must Be Different From The Old Password",
                maxLines: 2,
                      textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: AppColors.textSecondary,
                  fontFamily: 'Montserrat'
                ),
              ),
            ),
          ),
          
                
          SizedBox(height: height * 0.04),
                
          Center(
            child: Container(
              width: width * 0.9,
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
                      child: TextField(
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

                  SizedBox(height: height * 0.015),

                  /// Password Field
                  Center(
                    child: Container(
                      width: width * 0.9,
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
                      child: TextField(
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
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                
          /// ✅ reset Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: SizedBox(
              width: double.infinity,
              height: height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Change password",
                  style: TextStyle(
                    fontSize: width * 0.045,
                    color: AppColors.background,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ),
                
          SizedBox(height: height * 0.02),
                   
        ],
                ),
              )])),
    );
  }
}