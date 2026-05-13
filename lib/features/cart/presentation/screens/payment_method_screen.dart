import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/cart/presentation/screens/add_card_screen.dart';
import 'package:millio/features/cart/presentation/screens/qr_scan_screen.dart';
import 'package:millio/features/cart/presentation/screens/saved_cards_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethodId = 'mastercard';
  String? _selectedCardId;

  final List<Map<String, String>> _paymentMethods = [
    {'id': 'mastercard', 'title': 'Mastercard', 'image': 'assets/images/MasterCard.png'},
    {'id': 'paypal', 'title': 'PayPal', 'image': 'assets/images/Paypal.png'},
    {'id': 'visa', 'title': 'Visa', 'image': 'assets/images/Visa.png'},
    {'id': 'applepay', 'title': 'Apple Pay', 'image': 'assets/images/apple.png'},
    {'id': 'mycards', 'title': 'My Cards', 'image': 'assets/images/Wallet.png'},
    {'id': 'payondelivery', 'title': 'Pay on Delivery', 'image': 'assets/images/Wallet.png'},
  ];

  @override
  Widget build(BuildContext context) {
                final colors = context.colors;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
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
                    "Payment Method",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // QR Scanner Button
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
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
                  final isMyCards = method['id'] == 'mycards';
                  final isSelected = isMyCards
                    ? _selectedCardId != null
                    : _selectedMethodId == method['id'];

                  return GestureDetector(
                    onTap: () async {
                      if (isMyCards) {
                        final result = await Navigator.push<String>(
                          context,
                          MaterialPageRoute(builder: (context) => const SavedCardsScreen()),
                        );
                        if (result != null) {
                          setState(() {
                            _selectedCardId = result;
                            _selectedMethodId = 'mycards';
                          });
                        }
                      } else {
                        setState(() {
                          _selectedMethodId = method['id']!;
                          _selectedCardId = null;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      height: h * 0.06,
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(bottom: h * 0.02),
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.textField : colors.textField,
                        borderRadius: BorderRadius.circular(w * 0.1),
                        border: Border.all(
                          color: isSelected ? AppColorsLegacy.primary : AppColors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                              ? AppColorsLegacy.primary.withOpacity(0.08)
                              : AppColorsLegacy.textPrimary.withOpacity(0.06),
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
                              isMyCards && _selectedCardId != null
                                ? 'Card ending in ...${_selectedCardId!.length > 4 ? _selectedCardId!.substring(_selectedCardId!.length - 4) : ''}'
                                : method['title']!,
                              style: TextStyle(
                                fontSize: w * 0.038,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: colors.textPrimary,
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
                                color: isSelected ? AppColorsLegacy.primary : AppColorsLegacy.backgroundSecondary1,
                                width: 1.5,
                              ),
                              color: isSelected ? AppColorsLegacy.primary : AppColors.transparent,
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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddCardScreen()),
                        );
                        if (result != null && mounted) {
                          setState(() {
                            _selectedCardId = 'from_add';
                            _selectedMethodId = 'mycards';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.textField,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text(
                        "Add new card",
                        style: TextStyle(
                          color: AppColorsLegacy.primary,
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
                        final result = _selectedCardId != null
                          ? 'card_$_selectedCardId'
                          : _selectedMethodId;
                        Navigator.pop(context, result);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsLegacy.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: AppColorsLegacy.background,
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
