import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/services/auth_service.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/cart/data/models/address_model.dart';
import 'package:millio/features/cart/presentation/screens/set_location_screen.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  bool _isDefaultAddress = false;
  bool _isLoading = false;

  final _labelController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _labelController.dispose();
    _fullNameController.dispose();
    _countryController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress() async {
    final user = AuthService().currentUser;
    if (user == null) return;

    if (_labelController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an address title")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final addressId = await DatabaseService().saveAddress(
        uid: user.uid,
        label: _labelController.text.trim(),
        fullName: _fullNameController.text.trim(),
        country: _countryController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        isDefault: _isDefaultAddress,
        latitude: _latitude,
        longitude: _longitude,
      );

      if (!mounted) return;

      final address = Address(
        id: addressId,
        label: _labelController.text.trim(),
        fullName: _fullNameController.text.trim(),
        country: _countryController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        isDefault: _isDefaultAddress,
        latitude: _latitude,
        longitude: _longitude,
      );

      Navigator.pop(context, address);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save address: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
            final colors = context.colors;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColorsLegacy.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    "Add New Address",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.01),
                    
                    // --- ADDRESS TITLE FIELD ---
                    _buildTextField(
                      hint: "Address Title (e.g. Home, Work)",
                      imagePath: "assets/images/Edit.png",
                      w: w,
                      controller: _labelController,
                    ),
                    
                    SizedBox(height: h * 0.025),

                    // --- MAP SECTION ---
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SetLocationScreen()),
                        );
                      },
                      child: Container(
                        height: h * 0.38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColorsLegacy.background,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColorsLegacy.textPrimary.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Top Part: Actual Google Map with padding
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                    children: [
                                      GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: const CameraPosition(
                                          target: LatLng(37.42796133580664, -122.085749655962),
                                          zoom: 14.4746,
                                        ),
                                        onMapCreated: (GoogleMapController controller) {},
                                        onTap: (_) {
                                           Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const SetLocationScreen()),
                                          );
                                        },
                                        myLocationEnabled: false,
                                        myLocationButtonEnabled: false,
                                        zoomControlsEnabled: false,
                                      ),
                                      // Center Pin (Visual cue overlay)
                                       IgnorePointer(
                                        child: Center(
                                          child: Icon(Icons.location_on, color: AppColorsLegacy.primary, size: 38),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            // Bottom Part: Controls area
                            Padding(
                              padding: const EdgeInsets.only(top: 12, bottom: 20, left: 24, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Bottom Left: Set My Location (Just Text)
                                  Text(
                                    'Set My Location',
                                    style: TextStyle(
                                      color: AppColorsLegacy.textPrimary,
                                      fontSize: w * 0.035,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  // Bottom Right: Three Dot Menu
                                  Material(
                                    color: AppColors.transparent, 
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(25),
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: AppColorsLegacy.background,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColorsLegacy.backgroundSecondary1),
                                        ),
                                        child:  Icon(Icons.more_horiz, color: AppColorsLegacy.textPrimary, size: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // --- DETAILED FIELDS ---
                    _buildTextField(
                      hint: "Full Name",
                      imagePath: "assets/images/username.png",
                      w: w,
                      controller: _fullNameController,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Country / Region",
                      imagePath: "assets/images/Location.png",
                      w: w,
                      controller: _countryController,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Street Address",
                      imagePath: "assets/images/Location.png",
                      w: w,
                      controller: _streetController,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Town / City",
                      imagePath: "assets/images/Location.png",
                      w: w,
                      controller: _cityController,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Phone Number (with country code)",
                      imagePath: "assets/images/Call.png",
                      w: w,
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Email Address",
                      imagePath: "assets/images/Message.png",
                      w: w,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                    ),

                    SizedBox(height: h * 0.02),

                    // --- DEFAULT TOGGLE ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Set Default Address",
                          style: TextStyle(
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: colors.textPrimary,
                          ),
                        ),
                        // Custom Toggle
                        GestureDetector(
                          onTap: () => setState(() => _isDefaultAddress = !_isDefaultAddress),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: w * 0.11,
                            height: w * 0.062,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _isDefaultAddress ? AppColorsLegacy.primary : AppColorsLegacy.backgroundSecondary,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                            alignment: _isDefaultAddress ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: w * 0.048,
                              height: w * 0.048,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isDefaultAddress ? AppColorsLegacy.background : AppColorsLegacy.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.03),

                    // --- SAVE BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.06,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsLegacy.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Save Address",
                              style: TextStyle(
                                color: AppColorsLegacy.background,
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                      ),
                    ),
                    
                    SizedBox(height: h * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required String imagePath,
    required double w,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return _TextFieldWithFocus(
      hint: hint,
      imagePath: imagePath,
      w: w,
      controller: controller,
      keyboardType: keyboardType,
    );
  }
}

class _TextFieldWithFocus extends StatefulWidget {
  final String hint;
  final String imagePath;
  final double w;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _TextFieldWithFocus({
    required this.hint,
    required this.imagePath,
    required this.w,
    required this.controller,
    required this.keyboardType,
  });

  @override
  State<_TextFieldWithFocus> createState() => _TextFieldWithFocusState();
}

class _TextFieldWithFocusState extends State<_TextFieldWithFocus> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
                final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: _isFocused ? AppColorsLegacy.primaryLight : colors.textField,
        borderRadius: BorderRadius.circular(widget.w * 0.1),
        boxShadow: [
          BoxShadow(
            color: AppColorsLegacy.textPrimary.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isFocused ? AppColorsLegacy.primary : AppColors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        style: const TextStyle(
          fontFamily: 'Montserrat', 
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: AppColorsLegacy.textSecondary,
            fontSize: widget.w * 0.035,
            fontFamily: 'Montserrat',
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Image.asset(
              widget.imagePath,
              color: AppColorsLegacy.textSecondary,
              width: widget.w * 0.05,
              height: widget.w * 0.05,
              fit: BoxFit.contain,
            ),
          ),
          filled: true,
          fillColor: AppColors.transparent,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
