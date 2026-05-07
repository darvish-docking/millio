import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:millio/core/common/main_layout.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSelectionScreen extends StatefulWidget {
  final Map<String, String>? tempProfile;
  const LocationSelectionScreen({super.key, this.tempProfile});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController locationController = TextEditingController();
  
  LatLng _lastMapPosition = const LatLng(37.42796133580664, -122.085749655962);
  bool _isGettingAddress = false;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      setState(() {
        _isGettingAddress = true;
        locationController.text = "Getting address...";
      });
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _lastMapPosition.latitude,
        _lastMapPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          locationController.text = 
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        locationController.text = "Unknown Location";
      });
    } finally {
      setState(() {
        _isGettingAddress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: colors.background,
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
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: width * 0.10,
                      height: width * 0.10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.textHint.withOpacity(0.05),
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
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            /// Map area
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width * 0.06),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: _lastMapPosition,
                        zoom: 14.4746,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _getAddressFromLatLng();
                      },
                      onCameraMove: _onCameraMove,
                      onCameraIdle: () {
                        _getAddressFromLatLng();
                      },
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 35),
                        child: Icon(
                          Icons.location_on,
                          color: colors.primary,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
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
                      color: colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  _buildTextField(context, hint: "Selected Location", controller: locationController),
                  SizedBox(height: height * 0.04),

                  /// Final Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: height * 0.07,
                    child: ElevatedButton(
                      onPressed: () async {
                        final onboarding = context.read<OnboardingProvider>();
                        
                        try {
                          // Collect data from the previous screen and this one
                          final profile = widget.tempProfile ?? {};
                          
                          await onboarding.completeOnboarding(
                            full: profile['username'] ?? onboarding.username,
                            nick: profile['nickname'] ?? onboarding.nickname,
                            mail: profile['email'] ?? onboarding.email,
                            birth: profile['dob'] ?? onboarding.dob,
                            gen: profile['gender'] ?? onboarding.gender,
                            reg: profile['region'] ?? onboarding.region,
                            loc: locationController.text,
                          );

                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainLayout()),
                            (route) => false,
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsLegacy.primary,
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
                          color: AppColorsLegacy.background,
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

  Widget _buildTextField(BuildContext context, {required String hint, required TextEditingController controller}) {
    final colors = context.colors;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.09),
        color: colors.textField,
        boxShadow: [
          BoxShadow(
            color: AppColorsLegacy.textPrimary.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: width * 0.04, color: AppColorsLegacy.backgroundSecondary5, fontFamily: 'Montserrat'),
          filled: true,
          fillColor: colors.textField,
          contentPadding: EdgeInsets.symmetric(vertical: height * 0.022, horizontal: width * 0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(width * 0.09), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(width * 0.09), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(width * 0.09), borderSide: BorderSide(color: AppColorsLegacy.primary, width: 2)),
        ),
      ),
    );
  }
}
