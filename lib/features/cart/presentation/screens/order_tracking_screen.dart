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
    const Polyline(
      polylineId: PolylineId('route'),
      color: AppColors.primary,
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
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
          // ─── GOOGLE MAP — fills the entire screen background ───────────────
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

          // ─── HEADER overlaid on map ────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
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
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04, vertical: h * 0.01),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── BOTTOM GRAY PANEL ─────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: h * 0.45,
              decoration: const BoxDecoration(
                color: Colors.black,

                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  // ── Upper section (padded) ───────────────────────────────
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.06, vertical: h * 0.018),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: w * 0.1,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.014),

                        // ── Estimated Time ───────────────────────────────────────
                        Text(
                          "Estimated delivery time is 5 minutes",
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: h * 0.005),
                        Text(
                          "Your order is already on its way to you",
                          style: TextStyle(
                            fontSize: w * 0.03,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            color: Colors.white60,
                          ),
                        ),

                        SizedBox(height: h * 0.022),

                        // ── Order Lifecycle Tracker ──────────────────────────────
                        Row(
                          children: [
                            // Step 1 — Order Placed
                            _buildStepIcon(
                              child: Icon(Icons.receipt_long_rounded,
                                  color: AppColors.primary, size: w * 0.048),
                              w: w,
                            ),
                            Expanded(child: _DashedLine(color: AppColors.primary)),
                            // Step 2 — In Transit (current)
                            _buildStepIcon(
                              child: Image.asset(
                                'assets/images/cart-icon.png',
                                width: w * 0.048,
                                height: w * 0.048,
                                color: AppColors.primary,
                                fit: BoxFit.contain,
                              ),
                              w: w,
                            ),
                            Expanded(child: _DashedLine(color: Colors.white)),
                            // Step 3 — Delivered
                            _buildStepIcon(
                              child: Icon(Icons.check,
                                  color: Colors.black, size: w * 0.04),
                              w: w,
                              size: w * 0.08,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8),
                              bgColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // ── Lower Gray Container (Delivery Partner) ────────────────
                  Container(
                    height: h * 0.11, // Roughly 1/4 of h*0.45
                    decoration: const BoxDecoration(
                      color: Color(0xFF2A2A2A), // Dark gray
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: w * 0.06,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white, size: w * 0.06),
                        ),
                        SizedBox(width: w * 0.04),
                        // Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Serenity Fisher",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.04,
                                ),
                              ),
                              Text(
                                "Courier",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontFamily: 'Montserrat',
                                  fontSize: w * 0.03,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Call button
                        Container(
                          padding: EdgeInsets.all(w * 0.025),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.call, color: Colors.white, size: w * 0.05),
                        ),
                        SizedBox(width: w * 0.03),
                        // Warning button
                        Container(
                          padding: EdgeInsets.all(w * 0.025),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: w * 0.05),
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

  // ─── Step Icon Builder ────────────────────────────────────────────────────
  Widget _buildStepIcon({
    required Widget child,
    required double w,
    double? size,
    Color bgColor = Colors.transparent,
    BoxShape shape = BoxShape.circle,
    BorderRadiusGeometry? borderRadius,
    Border? border,
  }) {
    final double s = size ?? (w * 0.12);
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        color: bgColor,
        shape: shape,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Center(child: child),
    );
  }
}

// ─── Dashed Line Painter ────────────────────────────────────────────────────
class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color),
      child: const SizedBox(height: 2),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    final y = size.height / 2;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
