import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:millio/core/constants/app_colors.dart';

class PaymentFailureScreen extends StatelessWidget {
  final String errorMessage;
  final DateTime dateTime;

  const PaymentFailureScreen({
    super.key,
    required this.errorMessage,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.08;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            // --- FAILURE ICON ---
            Center(
              child: Container(
                width: w * 0.25,
                height: w * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: w * 0.18,
                    height: w * 0.18,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.background,
                      size: w * 0.1,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.03),
            // --- TITLE ---
            Text(
              "Payment Failed",
              style: TextStyle(
                fontSize: w * 0.065,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: h * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Text(
                "We couldn't process your payment. Please check your payment details or try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: w * 0.035,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(height: h * 0.05),

            // --- ERROR DETAILS CARD ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Container(
                padding: EdgeInsets.all(w * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildDetailRow("Error", errorMessage, w),
                    const Divider(height: 30),
                    _buildDetailRow("Date", DateFormat('dd MMM yyyy').format(dateTime), w),
                    const Divider(height: 30),
                    _buildDetailRow("Time", DateFormat('hh:mm a').format(dateTime), w),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // --- BOTTOM BUTTONS ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.03),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        // Go back to Payment Method Screen
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Try Again",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Back to Cart",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.035,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: w * 0.035,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
