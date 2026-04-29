import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:millio/features/cart/presentation/screens/payment_success_screen.dart';
import 'package:millio/features/cart/presentation/screens/payment_failure_screen.dart';
import 'package:millio/features/cart/presentation/screens/add_card_screen.dart';
import 'package:millio/features/cart/presentation/screens/qr_scan_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  late Razorpay _razorpay;

  String _selectedMethodId = 'mastercard';

  final List<Map<String, String>> _paymentMethods = [
    {'id': 'mastercard', 'title': 'Mastercard', 'image': 'assets/images/MasterCard.png'},
    {'id': 'paypal', 'title': 'PayPal', 'image': 'assets/images/Paypal.png'},
    {'id': 'visa', 'title': 'Visa', 'image': 'assets/images/Visa.png'},
    {'id': 'applepay', 'title': 'Apple Pay', 'image': 'assets/images/apple.png'},
    {'id': 'payondelivery', 'title': 'Pay on Delivery', 'image': 'assets/images/Wallet.png'},
  ];


  @override
  void initState(){
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose(){
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_SiVFO1Fm7aO4WZ',
      'amount': 5000, 
      'currency': 'INR',
      'name': 'Millio Corporation',
      'description': 'Food Delivery Order',
      // 'order_id': 'order_EMBFqjDHEEn80l', // Requires a valid active order ID, commented for test
      'timeout': 60, // in seconds
      'prefill': {
        'contact': '9876543210',
        'email': 'customer@millio.com'
      }
    };
    
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("SUCCESS: ${response.paymentId}");
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          transactionId: response.paymentId ?? "N/A",
          amount: "₹50.00", // This should be dynamic in a real app
          dateTime: DateTime.now(),
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("ERROR: ${response.code} - ${response.message}");
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailureScreen(
          errorMessage: response.message ?? "Unknown Error",
          dateTime: DateTime.now(),
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("WALLET: ${response.walletName}");
  }

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
                    "Payment Method",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // QR Scanner Button
                  Material(
                    color: AppColors.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrScanScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Image.asset(
                          "assets/images/Scan.png",
                          width: w * 0.05,
                          height: w * 0.05,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- PAYMENT OPTIONS LIST ---
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  final method = _paymentMethods[index];
                  final isSelected = _selectedMethodId == method['id'];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMethodId = method['id']!;
                      });
                    },
                    child: AnimatedContainer(
                      height: h * 0.06,
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(bottom: h * 0.02),
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : AppColors.background,
                        borderRadius: BorderRadius.circular(w * 0.1), // Pill shaped like textfields
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                              ? AppColors.primary.withOpacity(0.08)
                              : AppColors.textPrimary.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Brand Icon
                          Image.asset(
                            method['image']!,
                            width: w * 0.1,
                            height: w * 0.1,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: w * 0.04),
                          // Title
                          Expanded(
                            child: Text(
                              method['title']!,
                              style: TextStyle(
                                fontSize: w * 0.038,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          // Rounded Checkbox
                          Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.backgroundSecondary1,
                                width: 1.5,
                              ),
                              color: isSelected ? AppColors.primary : AppColors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- BOTTOM BUTTONS ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  // Add New Card Button (Secondary Style)
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddCardScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        "Add new card",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: w * 0.035,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                  // Apply Button (Primary Style)
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        _openCheckout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: w * 0.038,
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
          ],
        ),
      ),
    );
  }
}




