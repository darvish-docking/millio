import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:millio/core/constants/app_colors.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isFlashOn = false;
  bool _hasScanned = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      debugPrint('Barcode found! ${barcode.rawValue}');
      setState(() {
        _hasScanned = true;
      });
      // Optionally pop back or navigate upon successful scan
      // Future.delayed(const Duration(seconds: 1), () {
      //   if (mounted) Navigator.pop(context, barcode.rawValue);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/snacks.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Blur Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: AppColors.textPrimary.withOpacity(0.6),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
                  child: Row(
                    children: [
                      Material(
                        color: AppColors.textWhite24,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.025),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: w * 0.045,
                              color: AppColors.background,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.04),
                      Text(
                        "Scan QR Code",
                        style: TextStyle(
                          fontSize: w * 0.055,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: AppColors.background,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Scanner Area
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Custom corner brackets outside the frame
                          CustomPaint(
                            size: Size(w * 0.7 + 40, w * 0.9 + 40),
                            painter: _ScannerOverlayPainter(),
                          ),
                          // Scanner Frame
                          Container(
                            width: w * 0.7,
                            height: w * 0.9,
                            decoration: BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                          child: Stack(
                            children: [
                              MobileScanner(
                                controller: _scannerController,
                                onDetect: _onDetect,
                              ),
                              if (_hasScanned)
                                Container(
                                  color: AppColors.buttonPrimary.withOpacity(0.3),
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: AppColors.background,
                                      size: 80,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      ],
                    ),
                      SizedBox(height: h * 0.03),
                      // Text(
                      //   _hasScanned ? "Scan Successful!" : "Align QR code within the frame",
                      //   style: TextStyle(
                      //     color: Colors.white70,
                      //     fontFamily: 'Montserrat',
                      //     fontSize: w * 0.04,
                      //     fontWeight: _hasScanned ? FontWeight.bold : FontWeight.normal,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                const Spacer(),

                // Flash Toggle Button
                Padding(
                  padding: EdgeInsets.only(bottom: h * 0.05),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Material(
                        color: _isFlashOn ? AppColors.background : AppColors.textWhite24,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {
                            _scannerController.toggleTorch();
                            setState(() {
                              _isFlashOn = !_isFlashOn;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(w * 0.04),
                            child: Icon(
                              _isFlashOn ? Icons.flash_on : Icons.flash_off,
                              color: _isFlashOn ? AppColors.textPrimary : AppColors.background,
                              size: w * 0.08,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        _isFlashOn ? "Flash On" : "Flash Off",
                        style: TextStyle(
                          color: AppColors.background,
                          fontFamily: 'Montserrat',
                          fontSize: w * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.background
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 30.0;
    const double radius = 16.0;

    // Top-Left
    var path = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..lineTo(cornerLength, 0);
    canvas.drawPath(path, paint);

    // Top-Right
    path = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(path, paint);

    // Bottom-Left
    path = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - radius)
      ..quadraticBezierTo(0, size.height, radius, size.height)
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(path, paint);

    // Bottom-Right
    path = Path()
      ..moveTo(size.width, size.height - cornerLength)
      ..lineTo(size.width, size.height - radius)
      ..quadraticBezierTo(size.width, size.height, size.width - radius, size.height)
      ..lineTo(size.width - cornerLength, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
