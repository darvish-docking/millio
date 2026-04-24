import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/screens/location_selection_screen.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() =>
      _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState
    extends State<ProfileDetailsScreen> {

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController nickNameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController dobController =
      TextEditingController();

  final TextEditingController genderController =
      TextEditingController();

  final TextEditingController regionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                children: [
                  GestureDetector(
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

                  SizedBox(width: width * 0.04),

                  Text(
                    "Setup Profile",
                    style: TextStyle(
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.05),

              /// Profile Image
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: width * 0.32,
                      width: width * 0.32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundSecondary1,
                        // border: Border.all(
                        //   color: Colors.grey.shade300,
                        //   width: 2,
                        // ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: width * 0.15,
                        color: AppColors.backgroundSecondary5,
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: width * 0.09,
                        width: width * 0.09,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                          border: Border.all(
                            color: AppColors.background,
                            width: 2,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/gallery.png',
                          color: AppColors.background,
                          width: width * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.05),

              /// Fields
              _buildTextField(
                context,
                hint: "Full Name",
                // icon: Icons.person_outline,
              ),

              SizedBox(height: height * 0.02),

              _buildTextField(
                context,
                hint: "Nick Name",
                // icon: Icons.badge_outlined,
              ),

              SizedBox(height: height * 0.02),

              _buildTextField(
                context,
                hint: "Email",
                // icon: Icons.email_outlined,
              ),

              SizedBox(height: height * 0.02),

              _buildTextField(
                context,
                hint: "Date of Birth",
                // icon: Icons.cake_outlined,
                suffixImage: 'assets/images/Calendar.png',
                onSuffixTap: () {
    showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
  },
              ),

              SizedBox(height: height * 0.02),

              _buildTextField(
                context,
                hint: "Gender",
                // icon: Icons.person_2_outlined,
                suffixImage: 'assets/images/down-arrow.png',
                onSuffixTap: () {
                    showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              title: const Text("Male"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Female"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Other"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
  },
              ),

              SizedBox(height: height * 0.02),

              _buildTextField(
                context,
                hint: "Region",
                // icon: Icons.location_on_outlined,
                suffixImage: 'assets/images/down-arrow.png',
                onSuffixTap: () {
                    showCountryPicker(
    context: context,
    showPhoneCode: false,
    onSelect: (Country country) {
      regionController.text = country.name;
    },
  );
  },
              ),

              SizedBox(height: height * 0.05),

              /// Continue Button
              SizedBox(
                width: double.infinity,
                height: height * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.09),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String hint,
    // required IconData icon,
    String? suffixImage,
    VoidCallback? onSuffixTap,
  }) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(width * 0.09),

      color: AppColors.background,

      boxShadow: [
        BoxShadow(
          color: AppColors.textPrimary.withOpacity(0.06),
          blurRadius: 12,
          spreadRadius: 1,
          offset: Offset(0, 4), // x,y
        ),
      ],
    ),
    child: TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: width * 0.04,
          color: AppColors.backgroundSecondary5,
          fontFamily: 'Montserrat'
        ),
        // prefixIcon: Icon(
        //   icon,
        //   color: Colors.grey.shade600,
        //   size: width * 0.055,
        // ),
        suffixIcon: suffixImage != null
            ? IconButton(
              onPressed: onSuffixTap,
              splashRadius: width * 0.06,
              icon: Padding(
              padding: EdgeInsets.all(width * 0.035),
              child: Image.asset(
                suffixImage,
                width: width * 0.05,
                height: width * 0.05,
              ),
            ))
            : null,
        filled: true,
        fillColor: AppColors.background,
        contentPadding: EdgeInsets.symmetric(
          vertical: height * 0.022,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.09),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.09),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.09),
          borderSide: BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
        ),
      ),
    ));
  }
}