import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/cart/presentation/screens/order_tracking_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String transactionId;
  final String amount;
  final DateTime dateTime;

  const PaymentSuccessScreen({
    super.key,
    required this.transactionId,
    required this.amount,
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
            // --- SUCCESS ICON ---
            Center(
              child: Container(
                width: w * 0.25,
                height: w * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: w * 0.18,
                    height: w * 0.18,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
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
              "Payment Successful!",
              style: TextStyle(
                fontSize: w * 0.065,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: h * 0.01),
            Text(
              "Your order has been placed successfully",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.035,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: h * 0.05),

            // --- TRANSACTION DETAILS CARD ---
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
                    _buildDetailRow("Transaction ID", transactionId, w),
                    const Divider(height: 30),
                    _buildDetailRow("Date", DateFormat('dd MMM yyyy').format(dateTime), w),
                    const Divider(height: 30),
                    _buildDetailRow("Time", DateFormat('hh:mm a').format(dateTime), w),
                    const Divider(height: 30),
                    _buildDetailRow("Amount", amount, w, isBold: true),
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Back to Cart",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  // Track Order Button (secondary)
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OrderTrackingScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        "Track My Order",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
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

  Widget _buildDetailRow(String label, String value, double w, {bool isBold = false}) {
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
        Text(
          value,
          style: TextStyle(
            fontSize: w * 0.035,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
