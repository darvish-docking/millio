import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:millio/core/constants/app_colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  GoogleMapController? _mapController;

  // Start: Restaurant | End: Customer
  static const LatLng _origin = LatLng(19.0760, 72.8777);
  static const LatLng _destination = LatLng(19.0900, 72.8656);

  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('origin'),
      position: _origin,
      infoWindow: InfoWindow(title: 'Restaurant'),
    ),
    const Marker(
      markerId: MarkerId('destination'),
      position: _destination,
      infoWindow: InfoWindow(title: 'Your Location'),
    ),
  };

  final Set<Polyline> _polylines = {
     Polyline(
      polylineId: PolylineId('route'),
      color: AppColorsLegacy.primary,
      width: 4,
      points: [_origin, _destination],
    ),
  };

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
            // --- GOOGLE MAP ---
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(19.0830, 72.8716),
                  zoom: 13.5,
                ),
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (controller) => _mapController = controller,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
            ),

            // --- HEADER ---
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
                child: Row(
                  children: [
                    Material(
                      color: colors.surface,
                      shape: const CircleBorder(),
                      elevation: 4,
                      shadowColor: Colors.black26,
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(w * 0.025),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            size: w * 0.045,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: w * 0.04),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "Order Tracking",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- BOTTOM TRACKING PANEL ---
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: h * 0.42,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.015),
                    // Drag Handle
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: colors.textSecondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Estimated Delivery",
                                    style: TextStyle(
                                      color: colors.textSecondary,
                                      fontSize: w * 0.032,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    "05:30 PM",
                                    style: TextStyle(
                                      color: colors.textPrimary,
                                      fontSize: w * 0.05,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColorsLegacy.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "On the way",
                                  style: TextStyle(
                                    color: AppColorsLegacy.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.03,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.03),

                          // Progress Tracker
                          Row(
                            children: [
                              _buildStepIcon(Icons.receipt_long, true, colors),
                              _buildLine(true),
                              _buildStepIcon(Icons.directions_bike, true, colors),
                              _buildLine(false),
                              _buildStepIcon(Icons.check_circle_outline, false, colors),
                            ],
                          ),
                          SizedBox(height: h * 0.03),

                          // Courier Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.textSecondary.withOpacity(0.1)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: const AssetImage('assets/images/username.png'),
                                  backgroundColor: colors.surface,
                                ),
                                SizedBox(width: w * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Serenity Fisher",
                                        style: TextStyle(
                                          color: colors.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.04,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      Text(
                                        "Food Delivery Courier",
                                        style: TextStyle(
                                          color: colors.textSecondary,
                                          fontSize: w * 0.03,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _buildActionIcon(Icons.call, AppColorsLegacy.primary),
                                    SizedBox(width: w * 0.02),
                                    _buildActionIcon(Icons.message, AppColorsLegacy.amber),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIcon(IconData icon, bool isCompleted, dynamic colors) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted ? AppColorsLegacy.primary : colors.textSecondary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: isCompleted ? Colors.white : colors.textSecondary, size: 20),
    );
  }

  Widget _buildLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? AppColorsLegacy.primary : Colors.grey[300],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
