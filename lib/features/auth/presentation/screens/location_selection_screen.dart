import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:millio/core/common/main_layout.dart';

class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: height * 0.02,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: width * 0.10,
                      height: width * 0.10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.textPrimary.withOpacity(0.05),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/left-arrow.png",
                          width: width * 0.05,
                          height: width * 0.05,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Text(
                    "Set Your Location",
                    style: TextStyle(
                      fontSize: width * 0.055,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            /// Map area (takes ~1/2 screen)
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.06),
                ),
                clipBehavior: Clip.antiAlias,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.42796133580664, -122.085749655962),
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    // map interaction controller
                  },
                  myLocationEnabled: false, // Turn on if permissions are handled
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
            
            SizedBox(height: height * 0.03),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose a place on the map",
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimarylight87,
                    ),
                  ),
                  
                  SizedBox(height: height * 0.02),

                  _buildTextField(
                    context,
                    hint: "Selected Location",
                    controller: locationController,
                  ),

                  SizedBox(height: height * 0.04),

                  /// Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.07,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action for Go to shopping
                        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const MainLayout(),
  ),
);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary, // As requested
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.09),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Go to shopping",
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String hint,
    required TextEditingController controller,
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
            offset: const Offset(0, 4), // x,y
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: true, // For mocked map interaction
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: width * 0.04,
            color: AppColors.backgroundSecondary5,
            fontFamily: 'Montserrat',
          ),
          filled: true,
          fillColor: AppColors.background,
          contentPadding: EdgeInsets.symmetric(
            vertical: height * 0.022,
            horizontal: width * 0.05,
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
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
