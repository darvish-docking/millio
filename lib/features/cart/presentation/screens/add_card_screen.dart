import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:millio/core/constants/app_colors.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  bool _isDefaultCard = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    _expiryController.dispose();
    super.dispose();
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
                    "Add New Card",
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

            // --- SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    // --- CREDIT CARD VISUAL ---
                    Center(
                      child: Image.asset('assets/images/Card.png',
                      width: w,
                      height: h * 0.25,
                      fit: BoxFit.fill,)
                      // Container(
                      //   width: double.infinity,
                      //   height: h * 0.22,
                      //   decoration: BoxDecoration(
                      //     gradient: const LinearGradient(
                      //       colors: [Color(0xFF62C222), Color(0xFF388E3C)],
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomRight,
                      //     ),
                      //     borderRadius: BorderRadius.circular(24),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: AppColors.primary.withOpacity(0.35),
                      //         blurRadius: 24,
                      //         offset: const Offset(0, 10),
                      //       ),
                      //     ],
                      //   ),
                      //   padding: EdgeInsets.all(w * 0.06),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       // Top row: chip + logo
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           // Chip
                      //           Container(
                      //             width: w * 0.1,
                      //             height: w * 0.07,
                      //             decoration: BoxDecoration(
                      //               color: Colors.white.withOpacity(0.3),
                      //               borderRadius: BorderRadius.circular(6),
                      //             ),
                      //           ),
                      //           // Card brand logo
                      //           Image.asset(
                      //             'assets/images/MasterCard.png',
                      //             width: w * 0.12,
                      //             height: w * 0.08,
                      //             fit: BoxFit.contain,
                      //           ),
                      //         ],
                      //       ),

                      //       const Spacer(),

                      //       // Card Number
                      //       ValueListenableBuilder<TextEditingValue>(
                      //         valueListenable: _cardNumberController,
                      //         builder: (_, value, __) {
                      //           final display = value.text.isEmpty
                      //               ? '**** **** **** ****'
                      //               : value.text;
                      //           return Text(
                      //             display,
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: w * 0.045,
                      //               fontWeight: FontWeight.bold,
                      //               fontFamily: 'Montserrat',
                      //               letterSpacing: 2,
                      //             ),
                      //           );
                      //         },
                      //       ),

                      //       SizedBox(height: h * 0.01),

                      //       // Cardholder Name + Expiry
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           // Name
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 "CARD HOLDER",
                      //                 style: TextStyle(
                      //                   color: Colors.white70,
                      //                   fontSize: w * 0.025,
                      //                   fontFamily: 'Montserrat',
                      //                 ),
                      //               ),
                      //               ValueListenableBuilder<TextEditingValue>(
                      //                 valueListenable: _nameController,
                      //                 builder: (_, value, __) {
                      //                   return Text(
                      //                     value.text.isEmpty ? 'Full Name' : value.text.toUpperCase(),
                      //                     style: TextStyle(
                      //                       color: Colors.white,
                      //                       fontSize: w * 0.033,
                      //                       fontWeight: FontWeight.w600,
                      //                       fontFamily: 'Montserrat',
                      //                     ),
                      //                   );
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //           // Expiry
                      //           Column(
                      //             crossAxisAlignment: CrossAxisAlignment.end,
                      //             children: [
                      //               Text(
                      //                 "EXPIRES",
                      //                 style: TextStyle(
                      //                   color: Colors.white70,
                      //                   fontSize: w * 0.025,
                      //                   fontFamily: 'Montserrat',
                      //                 ),
                      //               ),
                      //               ValueListenableBuilder<TextEditingValue>(
                      //                 valueListenable: _expiryController,
                      //                 builder: (_, value, __) {
                      //                   return Text(
                      //                     value.text.isEmpty ? 'MM/YY' : value.text,
                      //                     style: TextStyle(
                      //                       color: Colors.white,
                      //                       fontSize: w * 0.033,
                      //                       fontWeight: FontWeight.w600,
                      //                       fontFamily: 'Montserrat',
                      //                     ),
                      //                   );
                      //                 },
                      //               ),
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),

                    SizedBox(height: h * 0.035),

                    // --- FULL NAME FIELD ---
                    _buildTextField(
                      hint: "Full Name",
                      imagePath: "assets/images/username.png",
                      controller: _nameController,
                      w: w,
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: h * 0.02),

                    // --- CARD NUMBER FIELD ---
                    _buildTextField(
                      hint: "Card Number",
                      imagePath: "assets/images/Wallet.png",
                      controller: _cardNumberController,
                      w: w,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _CardNumberInputFormatter(),
                        LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                      ],
                    ),
                    SizedBox(height: h * 0.02),

                    // --- CVV AND EXPIRY ROW ---
                    _buildTextField(
                      hint: "CVV",
                      imagePath: "assets/images/Edit.png",
                      controller: _cvvController,
                      w: w,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                    ),
                    SizedBox(height: h * 0.02),
                    _buildTextField(
                      hint: "Exp Date",
                      imagePath: "assets/images/Calendar.png",
                      controller: _expiryController,
                      w: w,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ExpiryDateInputFormatter(),
                        LengthLimitingTextInputFormatter(5), // MM/YY
                      ],
                    ),

                    SizedBox(height: h * 0.03),

                    // --- SET DEFAULT CARD TOGGLE ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Set Default Card",
                          style: TextStyle(
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                            color: AppColors.textPrimarylight87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _isDefaultCard = !_isDefaultCard),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: w * 0.11,
                            height: w * 0.062,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _isDefaultCard ? AppColors.primary : AppColors.backgroundSecondary,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 2.5),
                            alignment: _isDefaultCard ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: w * 0.048,
                              height: w * 0.048,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isDefaultCard ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.1),

                    // --- ADD CARD BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.055,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: handle save card logic
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: Text(
                          "Add Card",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required String imagePath,
    required TextEditingController controller,
    required double w,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return _FocusableTextField(
      hint: hint,
      imagePath: imagePath,
      controller: controller,
      w: w,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
    );
  }
}

// ─── Focusable TextField Widget ────────────────────────────────────────────────
class _FocusableTextField extends StatefulWidget {
  final String hint;
  final String imagePath;
  final TextEditingController controller;
  final double w;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const _FocusableTextField({
    required this.hint,
    required this.imagePath,
    required this.controller,
    required this.w,
    required this.keyboardType,
    this.obscureText = false,
    this.inputFormatters,
  });

  @override
  State<_FocusableTextField> createState() => _FocusableTextFieldState();
}

class _FocusableTextFieldState extends State<_FocusableTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isFocused ? AppColors.primaryLight : AppColors.background,
        borderRadius: BorderRadius.circular(widget.w * 0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: _isFocused ? AppColors.primary : AppColors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        focusNode: _focusNode,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        inputFormatters: widget.inputFormatters,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: widget.w * 0.035,
            fontFamily: 'Montserrat',
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Image.asset(
              widget.imagePath,
              color: AppColors.textSecondary,
              width: widget.w * 0.05,
              height: widget.w * 0.05,
              fit: BoxFit.contain,
            ),
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}

// ─── Card Number Formatter (adds spaces every 4 digits) ────────────────────────
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ─── Expiry Date Formatter (MM/YY) ─────────────────────────────────────────────
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
