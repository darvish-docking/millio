import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:provider/provider.dart';



  class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
late TextEditingController fullNameController;
  late TextEditingController nickNameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController regionController;

    @override
  void initState() {
    super.initState();

    final profile =
        Provider.of<OnboardingProvider>(context, listen: false);

    /// Prefill values from provider
    fullNameController =
        TextEditingController(text: profile.username);

    nickNameController =
        TextEditingController(text: profile.nickname);

    emailController =
        TextEditingController(text: profile.email);

    dobController =
        TextEditingController(text: profile.dob);

    genderController =
        TextEditingController(text: profile.gender);

    regionController =
        TextEditingController(text: profile.region);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    nickNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    genderController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Row(
                children: [
                  Container(
                    height: width * 0.09,
                    width: width * 0.09,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary4.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.chevron_left,
                        color: AppColors.textPrimary,
                        size: width * 0.06,
                      ),
                    ),
                  ),

                  SizedBox(width: width * 0.04),

                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    height: width * 0.09,
                    width: width * 0.09,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary4.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                    'assets/images/Edit.png',
                    color: AppColors.textPrimary,
                    width: width * 0.085,
                  ),)
                ],
              ),

              SizedBox(height: height * 0.045),

              /// PROFILE IMAGE
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: width * 0.16,
                      backgroundImage:
                          const AssetImage("assets/images/profile.png"),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: Container(
                        height: width * 0.09,
                        width: width * 0.09,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: AppColors.background,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.photo_library_outlined,
                          color: AppColors.background,
                          size: width * 0.045,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02),

              /// USER NAME
              Center(
                child: Text(
                  "${context.watch<OnboardingProvider>().username}",
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),

              /// FIELDS
              buildField(
                controller: fullNameController,
                hint: "Full Name",
                width: width,
                height: height,
              ),

              SizedBox(height: height * 0.02),

              buildField(
                controller: nickNameController,
                hint: "Nick Name",
                width: width,
                height: height,
              ),

              SizedBox(height: height * 0.02),

              buildField(
                controller: emailController,
                hint: "Email",
                width: width,
                height: height,
              ),

              SizedBox(height: height * 0.02),

              buildField(
                controller: dobController,
                hint: "DOB",
                width: width,
                height: height,
                suffix: Icons.calendar_today_outlined,
                onTap: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  },
              ),

              SizedBox(height: height * 0.02),

              buildField(
                controller: genderController,
                hint: "Gender",
                width: width,
                height: height,
                suffix: Icons.keyboard_arrow_down,
                onTap: () {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                title: const Text("Male"),
                onTap: () {
                  genderController.text = "Male";
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Female"),
                onTap: () {
                  genderController.text = "Female";
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Other"),
                onTap: () {
                  genderController.text = "Other";
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

              buildField(
                controller: regionController,
                hint: "Region",
                width: width,
                height: height,
                suffix: Icons.keyboard_arrow_down,
                 onTap: () {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        regionController.text = country.name;
      },
    );
  },
              ),

              SizedBox(height: height * 0.06),

              /// UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<OnboardingProvider>().updateProfile(
                    full: fullNameController.text,
                    nick: nickNameController.text,
                    mail: emailController.text,
                    birth: dobController.text,
                    gen: genderController.text,
                    reg: regionController.text,
                  );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
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

  Widget buildField({
    required TextEditingController controller,
    required String hint,
    required double width,
    required double height,
    IconData? suffix,
    bool readOnly = false,
  VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
         readOnly: readOnly,
      onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: width * 0.04,
          ),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.022,
          ),
          suffixIcon: suffix != null
              ? Icon(
                  suffix,
                  color: AppColors.textSecondary,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}