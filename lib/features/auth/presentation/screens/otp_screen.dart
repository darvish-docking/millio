import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/profile_details_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
          child: Image.asset(
            "assets/images/otp-background.png",
            fit: BoxFit.fitHeight,
            width: double.infinity,
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
                "Verification",
                style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.bold,
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
                "We have sent the code verification to your Email",
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Text(
                "kenzi.lawson@example.com",
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
                
          SizedBox(height: height * 0.04),
                
          /// 🔢 OTP Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return Container(
                width: width * 0.15,
                height: height * 0.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.08), // soft shadow
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4), // downward shadow
                    ),
                  ],
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: width * 0.09,
                    fontWeight: FontWeight.bold,
                  ),
                
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: Colors.white,
                    /// 👇 background when focused
    focusColor: Color(0xFF62C222).withValues(alpha:  0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50), // oval shape
                      borderSide: BorderSide.none,
                    ),
                    /// 👇 border when NOT focused
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: AppColors.transparent),
    ),

    /// 👇 border when focused
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
                    
                  ),
                ),
              );
            }),
          ),
                
          SizedBox(height: height * 0.05),
                
          /// ✅ Confirm Button
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileDetailsScreen(),
                    ),
                  );
                },
                child: Text(
                  "Confirm",
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
                
          /// 🔁 Resend Section
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: TextStyle(fontSize: width * 0.035,
                  fontFamily: 'Montserrat',),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
          ),
                
        ],
                ),
              )])),
    );
  }
}