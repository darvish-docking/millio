import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



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

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Optimize image size
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

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
                final colors = context.colors;

    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: colors.background,
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
                      color: AppColorsLegacy.backgroundSecondary4.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.chevron_left,
                        color: AppColorsLegacy.textPrimary,
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
                      color: colors.textPrimary,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    height: width * 0.09,
                    width: width * 0.09,
                    decoration: BoxDecoration(
                      color: AppColorsLegacy.backgroundSecondary4.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                    'assets/images/Edit.png',
                    color: AppColorsLegacy.textPrimary,
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
                    GestureDetector(
                      onTap: _pickImage,
                      child: _imageFile != null
                          ? CircleAvatar(
                              radius: width * 0.16,
                              backgroundImage: FileImage(_imageFile!),
                            )
                          : Consumer<OnboardingProvider>(
                              builder: (context, provider, child) {
                                return CircleAvatar(
                                  radius: width * 0.16,
                                  backgroundImage: provider.profilePicture.isNotEmpty
                                      ? MemoryImage(base64Decode(provider.profilePicture))
                                      : const AssetImage("assets/images/profile.png") as ImageProvider,
                                );
                              },
                            ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: width * 0.09,
                          width: width * 0.09,
                          decoration: BoxDecoration(
                            color: AppColorsLegacy.primary,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: AppColorsLegacy.background,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: AppColorsLegacy.background,
                            size: width * 0.045,
                          ),
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
                  context.watch<OnboardingProvider>().username,
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
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

              buildSelector(
                value: dobController.text.isEmpty ? "DOB" : dobController.text,
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
                    setState(() {
                      dobController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
              ),

              SizedBox(height: height * 0.02),

              buildSelector(
                value: genderController.text.isEmpty ? "Gender" : genderController.text,
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
                                setState(() {
                                  genderController.text = "Male";
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text("Female"),
                              onTap: () {
                                setState(() {
                                  genderController.text = "Female";
                                });
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text("Other"),
                              onTap: () {
                                setState(() {
                                  genderController.text = "Other";
                                });
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

              buildSelector(
                value: regionController.text.isEmpty ? "Region" : regionController.text,
                width: width,
                height: height,
                suffix: Icons.keyboard_arrow_down,
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      setState(() {
                        regionController.text = country.name;
                      });
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
                      image: _imageFile,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColorsLegacy.primary,
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
                      color: AppColorsLegacy.background,
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
                final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColorsLegacy.textPrimary.withOpacity(0.06),
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
            color: AppColorsLegacy.textSecondary,
            fontSize: width * 0.04,
          ),
          filled: true,
          fillColor: colors.textField,
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: height * 0.022,
          ),
          suffixIcon: suffix != null
              ? Icon(
                  suffix,
                  color: AppColorsLegacy.textSecondary,
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
              color: AppColorsLegacy.primary,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSelector({
    required String value,
    required double width,
    required double height,
    required IconData suffix,
    required VoidCallback onTap,
  }) {
    final colors = context.colors;
    bool isPlaceholder = value == "DOB" || value == "Gender" || value == "Region";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.022,
        ),
        decoration: BoxDecoration(
          color: colors.textField,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColorsLegacy.textPrimary.withOpacity(0.06),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(
                color: isPlaceholder ? AppColorsLegacy.textSecondary : colors.textPrimary,
                fontSize: width * 0.04,
              ),
            ),
            Icon(
              suffix,
              color: AppColorsLegacy.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}