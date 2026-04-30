import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccessScreen extends StatefulWidget {
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
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  String _userEmail = "Tim.jennings@example.com"; // Default fallback

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString("email") ?? _userEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TOP IMAGE SECTION WITH STACK ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Background Image
                Container(
                  height: h * 0.35,
                  width: w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/paymentSuccess Bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Header Icons (Back & Search)
                Positioned(
                  top: h * 0.05,
                  left: w * 0.05,
                  right: w * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back_ios_new, size: w * 0.04, color: AppColors.textPrimary),
                        ),
                      ),
                      // Search Button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.search, size: w * 0.05, color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),

                // Overlapping Gift Box Image
                Positioned(
                  bottom: -h * 0.08,
                  child: Image.asset(
                    'assets/images/package.png',
                    width: w * 0.5,
                    height: w * 0.5,
                  ),
                ),
              ],
            ),

            SizedBox(height: h * 0.08),

            // --- THANKS TEXT ---
            Text(
              'Thanks For Your Order',
              style: TextStyle(
                fontSize: w * 0.06,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: h * 0.015),

            // Small Green Divider
            Container(
              width: w * 0.1,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            SizedBox(height: h * 0.03),

            // Email Notification Text
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.1),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'You’ll receive an email at '),
                    TextSpan(
                      text: _userEmail,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' once your order is confirm'),
                  ],
                ),
              ),
            ),

            SizedBox(height: h * 0.1), // Large Space

            // --- ORDER DETAILS BOX ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.08),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Separator
                    // Header with Separator Below
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Details",
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            color: AppColors.primary, // Brand Green
                          ),
                        ),
                        SizedBox(height: h * 0.005),
                        Divider(
                         // Fixed width for separator
                          height: 2,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),

                    // Details
                    _buildDetailItem("Order Number", "#MILL-${widget.transactionId.substring(0, 5).toUpperCase()}", w),
                    _buildDetailItem("Amount Paid", widget.amount, w),
                    _buildDetailItem("Transaction ID", widget.transactionId, w),
                    _buildDetailItem("Date", DateFormat('dd MMM yyyy').format(widget.dateTime), w),
                    _buildDetailItem("Time", DateFormat('hh:mm a').format(widget.dateTime), w),
                  ],
                ),
              ),
            ),

            SizedBox(height: h * 0.05),

            // --- CONTINUE SHOPPING BUTTON ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.08),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to HomeScreen and clear stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(
                      color: AppColors.background,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: h * 0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.032,
              fontFamily: 'Montserrat',
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: w * 0.032,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
