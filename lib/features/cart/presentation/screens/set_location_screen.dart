import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:millio/core/constants/app_colors.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  late GoogleMapController _mapController;
  final TextEditingController _addressController = TextEditingController(text: "123 Millio Street, Tech City");
  LatLng _lastMapPosition = const LatLng(37.42796133580664, -122.085749655962);
  bool _isFieldFocused = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onCameraIdle() {
    // In a real app, you would use reverse geocoding here.
    // Simulating address update based on new coordinates:
    setState(() {
      _addressController.text = "${_lastMapPosition.latitude.toStringAsFixed(4)}, ${_lastMapPosition.longitude.toStringAsFixed(4)} Road";
    });
  }

  @override
  Widget build(BuildContext context) {
                final colors = context.colors;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
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
                    "Set Location",
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

            // --- GOOGLE MAP (Half Screen, No Padding) ---
            SizedBox(
              height: h * 0.45,
              width: double.infinity,
              child: Stack(
                children: [
                   GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: _lastMapPosition,
                      zoom: 14.4746,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    onCameraMove: _onCameraMove,
                    onCameraIdle: _onCameraIdle,
                  ),
                  // Center Pin (The "Balloon")
                   IgnorePointer(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on, color: AppColorsLegacy.primary, size: 48),
                          SizedBox(height: 24), // Offset to put the tip at the center
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- SELECTION AREA ---
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose location from map",
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: colors.textPrimary,
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    
                    // --- ADDRESS FIELD (Matching AddAddress style) ---
                    _buildAddressField(w),

                    SizedBox(height: h * 0.04),

                    // --- CONFIRM BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.065,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsLegacy.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: Text(
                          "Confirm Location",
                          style: TextStyle(
                            color: AppColorsLegacy.background,
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressField(double w) {
                final colors = context.colors;

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFieldFocused = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: _isFieldFocused ? AppColorsLegacy.primaryLight : colors.textField,
          borderRadius: BorderRadius.circular(w * 0.1),
          boxShadow: [
            BoxShadow(
              color: AppColorsLegacy.textPrimary.withOpacity(0.06),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: _isFieldFocused ? AppColorsLegacy.primary : AppColors.transparent,
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: _addressController,
          style: const TextStyle(
            fontFamily: 'Montserrat', 
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Location Address",
            hintStyle: TextStyle(
              color: AppColorsLegacy.textSecondary,
              fontSize: w * 0.035,
              fontFamily: 'Montserrat',
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(
                "assets/images/Location.png",
                color: AppColorsLegacy.textSecondary,
                width: w * 0.05,
                height: w * 0.05,
                fit: BoxFit.contain,
              ),
            ),
            filled: true,
            fillColor: AppColors.transparent,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),
      ),
    );
  }
}
