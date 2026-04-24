import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class Voucher {
  final String id;
  final String title;
  final String details;
  final String imagePath;

  Voucher({
    required this.id,
    required this.title,
    required this.details,
    required this.imagePath,
  });
}

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String? _selectedVoucherId;

  final List<Voucher> _vouchers = [
    Voucher(
      id: '1',
      title: 'Free Delivery',
      details: 'On your first 3 orders above \$15',
      imagePath: 'assets/images/cart-icon.png',
    ),
     Voucher(
      id: '2',
      title: '15% Off Total',
      details: 'Valid for all restaurants today',
      imagePath: 'assets/images/Discount.png',
    ),
    Voucher(
      id: '3',
      title: 'Buy 1 Get 1',
      details: 'On selected pizza outlets',
      imagePath: 'assets/images/Fast Food.png',
    ),
    Voucher(
      id: '4',
      title: '\$5.00 Welcome Gift',
      details: 'New user special offer',
      imagePath: 'assets/images/Wallet.png',
    ),
  ];

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
                    "Voucher",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // --- VOUCHER LIST ---
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
                itemCount: _vouchers.length,
                itemBuilder: (context, index) {
                  final voucher = _vouchers[index];
                  final isSelected = _selectedVoucherId == voucher.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedVoucherId = voucher.id;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 0.02),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.transparent,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                              ? AppColors.primary.withValues(alpha: .05) 
                              : AppColors.textPrimary.withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Prefix Icon (Circle shaped)
                          Container(
                            width: w * 0.12,
                            height: w * 0.12,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.backgroundSecondary1,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(14), // Increased padding to reduce icon size
                            child: Image.asset(
                              voucher.imagePath,
                              color: isSelected ? Colors.white : Colors.black, // Active: white, Inactive: black
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: w * 0.04),

                          // Text Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  voucher.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  voucher.details,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: w * 0.03,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Suffix Small Round Checkbox (Solid green when selected)
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : AppColors.transparent,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.backgroundSecondary3,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- APPLY BUTTON ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.06,
                child: ElevatedButton(
                  onPressed: _selectedVoucherId == null 
                    ? null 
                    : () {
                        // Apply voucher logic
                        Navigator.pop(context, _vouchers.firstWhere((v) => v.id == _selectedVoucherId));
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Apply",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
