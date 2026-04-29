import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/cart/presentation/screens/set_location_screen.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  bool _isDefaultAddress = false;
  bool _isMapFocused = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: AppColors.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColors.textPrimary),
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
                      color: AppColors.textPrimary,
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
                    ),
                    
                    SizedBox(height: h * 0.025),

                    // --- MAP SECTION ---
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
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withOpacity(0.06),
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
                                      const IgnorePointer(
                                        child: Center(
                                          child: Icon(Icons.location_on, color: AppColors.primary, size: 38),
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
                                      color: AppColors.textPrimary,
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
                                          color: AppColors.background,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: AppColors.backgroundSecondary1),
                                        ),
                                        child: const Icon(Icons.more_horiz, color: AppColors.textPrimary, size: 22),
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
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Country / Region",
                      imagePath: "assets/images/Location.png",
                      w: w,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Street Address",
                      imagePath: "assets/images/Location.png",
                      w: w,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Town / City",
                      imagePath: "assets/images/Location.png",
                      w: w,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Phone Number (with country code)",
                      imagePath: "assets/images/Call.png",
                      w: w,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildTextField(
                      hint: "Email Address",
                      imagePath: "assets/images/Message.png",
                      w: w,
                      keyboardType: TextInputType.emailAddress,
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
                            color: AppColors.textPrimarylight87,
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
                              color: _isDefaultAddress ? AppColors.primary : AppColors.backgroundSecondary,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                            alignment: _isDefaultAddress ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: w * 0.048,
                              height: w * 0.048,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isDefaultAddress ? AppColors.background : AppColors.textPrimary,
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: Text(
                          "Save Address",
                          style: TextStyle(
                            color: AppColors.background,
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return _TextFieldWithFocus(
      hint: hint,
      imagePath: imagePath,
      w: w,
      keyboardType: keyboardType,
      onFocused: () {
        setState(() {
          _isMapFocused = false;
        });
      },
    );
  }
}

class _TextFieldWithFocus extends StatefulWidget {
  final String hint;
  final String imagePath;
  final double w;
  final TextInputType keyboardType;
  final VoidCallback onFocused;

  const _TextFieldWithFocus({
    required this.hint,
    required this.imagePath,
    required this.w,
    required this.keyboardType,
    required this.onFocused,
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
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_focusNode.hasFocus) {
        widget.onFocused();
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
    return Container(
      decoration: BoxDecoration(
        color: _isFocused ? AppColors.primaryLight : AppColors.background,
        borderRadius: BorderRadius.circular(widget.w * 0.1),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        style: const TextStyle(
          fontFamily: 'Montserrat', 
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: widget.w * 0.035,
            fontFamily: 'Montserrat',
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Image.asset(
              widget.imagePath,
              color: AppColors.textSecondary,
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
