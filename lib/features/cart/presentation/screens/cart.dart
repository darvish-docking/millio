import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/data/models/product_model.dart';
import 'package:millio/features/home/presentation/providers/home_provider.dart';
import 'package:millio/features/cart/presentation/providers/cart_provider.dart';
import 'package:millio/features/cart/presentation/screens/address_screen.dart';
import 'package:millio/features/cart/presentation/screens/voucher_screen.dart';
import 'package:millio/features/cart/presentation/screens/payment_method_screen.dart';
import 'package:millio/features/cart/presentation/screens/order_tracking_screen.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:millio/features/cart/presentation/screens/payment_success_screen.dart';
import 'package:millio/features/cart/presentation/screens/payment_failure_screen.dart';
import 'package:millio/features/cart/data/models/voucher_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/core/services/auth_service.dart';
import 'package:millio/features/home/presentation/screens/product_details.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Razorpay _razorpay = Razorpay();
  int _activeTabIndex = 0; // 0: Cart, 1: Checkout, 2: Delivery
  final List<String> _tabs = ["Cart", "Checkout", "Delivery"];
  
  // Track selected address for Checkout flow
  SavedAddress? _selectedAddress;
  String? _selectedPaymentMethodId;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Initialize with a default address matching the first one in AddressScreen
    _selectedAddress = SavedAddress(
      id: '1',
      label: 'Home',
      details: '23, Orchard Street, Near City Mall, New York, 10001',
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout(double totalAmount) {
    var options = {
      'key': dotenv.env['Razorpay_Test_API_key'],
      'amount': (totalAmount * 100).toInt(), 
      'currency': 'INR',
      'name': 'Millio Corporation',
      'description': 'Food Delivery Order',
      'timeout': 60,
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
    if (!mounted) return;
    final cart = Provider.of<CartProvider>(context, listen: false);
    final user = AuthService().currentUser;

    if (user != null) {
      DatabaseService().saveOrder(
        uid: user.uid,
        transactionId: response.paymentId ?? 'N/A',
        items: cart.items.map((item) => item.toMap()).toList(),
        subtotal: cart.subtotal,
        deliveryFee: cart.deliveryFee,
        discount: cart.discount,
        totalAmount: cart.total,
        status: 'Success',
        paymentMethod: _selectedPaymentMethodId ?? 'Razorpay',
        voucherId: cart.appliedVoucher?.id,
        voucherTitle: cart.appliedVoucher?.title,
        deliveryAddress: _selectedAddress?.details,
        deliveryAddressLabel: _selectedAddress?.label,
      );
    }

    final amountStr = '\$${cart.total.toStringAsFixed(2)}';
    final txId = response.paymentId ?? 'N/A';

    // Clear cart after saving
    cart.clearCart();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          transactionId: txId,
          amount: amountStr,
          dateTime: DateTime.now(),
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    
    // Better error message parsing
    String errorMsg = "Unknown Error";
    if (response.message != null && 
        response.message!.isNotEmpty && 
        response.message!.toLowerCase() != 'undefined') {
      errorMsg = response.message!;
    } else {
      // Fallback based on common Razorpay error codes
      switch (response.code) {
        case 2:
          errorMsg = "Payment cancelled by user";
          break;
        case 4:
          errorMsg = "Invalid request or network issue";
          break;
        case 5:
          errorMsg = "Payment method not supported";
          break;
        default:
          errorMsg = "Transaction failed (Code: ${response.code})";
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentFailureScreen(
          errorMessage: errorMsg,
          dateTime: DateTime.now(),
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("WALLET: ${response.walletName}");
  }

  Future<void> _onOrderNow(CartProvider cart) async {
    if (_selectedPaymentMethodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a payment method")),
      );
      return;
    }

    if (_selectedPaymentMethodId == 'payondelivery') {
      final user = AuthService().currentUser;
      final txId = "POD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}";
      final amountStr = "\$${cart.total.toStringAsFixed(2)}";
      final now = DateTime.now();

      if (user != null) {
        try {
          await DatabaseService().saveOrder(
            uid: user.uid,
            transactionId: txId,
            items: cart.items.map((item) => item.toMap()).toList(),
            subtotal: cart.subtotal,
            deliveryFee: cart.deliveryFee,
            discount: cart.discount,
            totalAmount: cart.total,
            status: 'Pending',
            paymentMethod: 'Pay on Delivery',
            voucherId: cart.appliedVoucher?.id,
            voucherTitle: cart.appliedVoucher?.title,
            deliveryAddress: _selectedAddress?.details,
            deliveryAddressLabel: _selectedAddress?.label,
          );
        } catch (e) {
          debugPrint('Order save error: $e');
        }
      }

      cart.clearCart();

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessScreen(
            transactionId: txId,
            amount: amountStr,
            dateTime: now,
          ),
        ),
      );
    } else {
      _openCheckout(cart.total);
    }
  }

  String _getPaymentMethodName(String id) {
    switch (id) {
      case 'mastercard': return 'Mastercard';
      case 'paypal': return 'PayPal';
      case 'visa': return 'Visa';
      case 'applepay': return 'Apple Pay';
      case 'payondelivery': return 'Pay on Delivery';
      default: return 'Payment method';
    }
  }

  @override
  Widget build(BuildContext context) {

                    final colors = context.colors;

    final cart = context.watch<CartProvider>();
    
    final homeProvider = context.watch<HomeProvider>();
    final products = homeProvider.products;
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
                    _tabs[_activeTabIndex],
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.search, size: w * 0.07, color: colors.textPrimary),
                ],
              ),
            ),

            // --- CUSTOM TAB SWITCHER (Electrical Wire Style) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.01),
              child: Column(
                children: [
                  Row(
                    children: List.generate(_tabs.length, (index) {
                      bool isActive = _activeTabIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTabIndex = index),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                fontSize: w * 0.038,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                color: isActive ? colors.textPrimary : colors.textSecondary,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: h * 0.015),
                  
                  // The "Electrical Wire"
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Gray Coil (Base Wire) - Reduced thickness
                      Container(
                        height: 2.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColorsLegacy.backgroundSecondary3,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      
                      // Green Coating (Sliding Sleeve) - Slightly thicker for sleeve effect
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left: (w - (padding * 2)) / _tabs.length * _activeTabIndex,
                        child: Container(
                          height: 4.5,
                          width: (w - (padding * 2)) / _tabs.length,
                          decoration: BoxDecoration(
                            color: AppColorsLegacy.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- CONTENT AREA ---
            Expanded(
              child: _activeTabIndex == 0 
                ? (cart.isEmpty ? _buildEmptyCartFlow(w, h, padding, products) : _buildCartItemsFlow(w, h, padding, cart))
                : (_activeTabIndex == 1 
                    ? _buildCheckoutFlow(w, h, padding, cart) 
                    : const OrderTrackingScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutFlow(double w, double h, double padding, CartProvider cart) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Delivery To" Section
          _buildDeliverySection(w, h),
          
          Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.02),
            child:  DashedDivider(color: AppColorsLegacy.divider),
          ),
          
          // Cart Items Display (Static)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              return _buildCartItemCard(w, h, padding, cart.items[index], cart, isStatic: true);
            },
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.01),
            child:  DashedDivider(color: AppColorsLegacy.divider),
          ),
          
          SizedBox(height: h * 0.02),

          // Promotions & Payment
          _buildVoucherButton(w),
          SizedBox(height: h * 0.015),
          _buildPaymentMethodButton(w),
          
          SizedBox(height: h * 0.04),
          
          // Pricing Summary
          _buildSummaryRow("Discount", "-\$${cart.discount.toStringAsFixed(2)}", true),
          SizedBox(height: h * 0.015),
          _buildSummaryRow("Total", "\$${cart.total.toStringAsFixed(2)}", false, isTotal: true),
          
          SizedBox(height: h * 0.05),
          
          // Order Now Button
          SizedBox(
            width: double.infinity,
            height: h * 0.07,
            child: ElevatedButton(
              onPressed: () => _onOrderNow(cart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsLegacy.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Text(
                "Order now",
                style: TextStyle(
                  color: AppColorsLegacy.background,
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
    );
  }

  Widget _buildDeliverySection(double w, double h) {
    return Row(
      children: [
        // Location Icon with Ring
        Container(
          width: w * 0.12,
          height: w * 0.12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColorsLegacy.primary.withOpacity(0.3), width: 2),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration:  BoxDecoration(
              color: AppColorsLegacy.primary,
              shape: BoxShape.circle,
            ),
            child:  Icon(Icons.location_on, color: AppColorsLegacy.background, size: 20),
          ),
        ),
        SizedBox(width: w * 0.04),
        
        // Address Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedAddress?.label ?? "Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.04,
                  fontFamily: 'Montserrat',
                ),
              ),
              SizedBox(height: h * 0.005),
              Text(
                _selectedAddress?.details ?? "23rd Street, New York, USA",
                style: TextStyle(
                  color: AppColorsLegacy.textSecondary,
                  fontSize: w * 0.03,
                  fontFamily: 'Montserrat',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        IconButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressScreen(
                  initialSelectedAddressId: _selectedAddress?.id,
                ),
              ),
            );
            if (result != null && result is SavedAddress) {
              setState(() {
                _selectedAddress = result;
              });
            }
          },
          icon:  Icon(Icons.chevron_right, color: AppColorsLegacy.textPrimary),
        ),
      ],
    );
  }

  Widget _buildVoucherButton(double w) {
    final cart = context.watch<CartProvider>();
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VoucherScreen()),
        );
        if (result != null && result is Voucher) {
          // cart.applyVoucher(result);
          context.read<CartProvider>()
    .applyVoucher(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColorsLegacy.primaryLight,
          borderRadius: BorderRadius.circular(30), // Rounded semi-circle type
        ),
        child: Row(
          children: [
            // Icon(Icons.local_offer, color: AppColorsLegacy.primary, size: w * 0.05),
                        Image.asset('assets/images/Discount.png'),
            SizedBox(width: w * 0.03),
             Expanded(
              child: Text(
                cart.appliedVoucher?.title ?? "Use voucher",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColorsLegacy.primary, // Green text
                ),
              ),
            ),
            if (cart.appliedVoucher != null)
              GestureDetector(
                onTap: () => context.read<CartProvider>()
    .removeVoucher(),
                child: Icon(Icons.close, color: AppColorsLegacy.primary, size: w * 0.05),
              )
            else
              Icon(Icons.chevron_right, color: AppColorsLegacy.primary, size: w * 0.06), // Green chevron
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(double w) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
        );
        if (result != null && result is String) {
          setState(() {
            _selectedPaymentMethodId = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColorsLegacy.primaryLight, // Matched with voucher color
          borderRadius: BorderRadius.circular(30), // Rounded semi-circle type
        ),
        child: Row(
          children: [
            // Icon(Icons.payment, color: AppColorsLegacy.primary, size: w * 0.05),
            Image.asset('assets/images/Wallet.png'),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Text(
                _selectedPaymentMethodId != null 
                  ? _getPaymentMethodName(_selectedPaymentMethodId!) 
                  : "Payment method",
                style:  TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColorsLegacy.primary, // Green text
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: AppColorsLegacy.primary, size: w * 0.06), // Green chevron
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderSection(String title) {
    return Center(
      child: Text(
        "Section $title Under Development",
        style:  TextStyle(fontFamily: 'Montserrat', color: AppColorsLegacy.textSecondary),
      ),
    );
  }

  Widget _buildCartItemsFlow(double w, double h, double padding, CartProvider cart) {
    return Column(
      children: [
        // Top Half: Scrollable Cart Items
        Expanded(
          flex: 1,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
            physics: const BouncingScrollPhysics(),
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return _buildCartItemCard(w, h, padding, item, cart);
            },
          ),
        ),
        
        // Dashed Divider
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child:  DashedDivider(color: AppColorsLegacy.divider),
        ),

        // Bottom Half: Vouchers, Offers, Total Summary
        Expanded(
          flex: 1,
          child: _buildCartCheckoutDetails(w, h, padding, cart),
        ),
      ],
    );
  }

  Widget _buildCartCheckoutDetails(double w, double h, double padding, CartProvider cart) {
                    final colors = context.colors;

print("DISCOUNT UI: ${cart.discount}");
print("TOTAL UI: ${cart.total}");
print("DELIVERY UI: ${cart.finalDeliveryFee}");

    double subtotal = cart.subtotal;
    double deliveryFee = cart.deliveryFee;
    double discount = cart.discount;
    double total = cart.total;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(35),
        //   topRight: Radius.circular(35),
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColorsLegacy.textPrimary.withOpacity(0.05),
        //     blurRadius: 20,
        //     offset: const Offset(0, -5),
        //   ),
        // ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            _buildVoucherButton(w),
            
            SizedBox(height: h * 0.03),
            
            // Order Summary Details
            _buildSummaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}", false),
            SizedBox(height: h * 0.015),
            _buildSummaryRow("Delivery Fee", "\$${deliveryFee.toStringAsFixed(2)}", false),
            SizedBox(height: h * 0.015),
            _buildSummaryRow("Discount", "-\$${discount.toStringAsFixed(2)}", true),
            
            Padding(
              padding: EdgeInsets.symmetric(vertical: h * 0.02),
              child: Divider(color: AppColorsLegacy.backgroundSecondary3, thickness: 1),
            ),
            
            _buildSummaryRow("Total", "\$${total.toStringAsFixed(2)}", false, isTotal: true),
            
            SizedBox(height: h * 0.03),
            
            // Main Checkout Button
            SizedBox(
              width: double.infinity,
              height: h * 0.07,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _activeTabIndex = 1; // Move to Checkout tab
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLegacy.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Proceed To Checkout",
                  style: TextStyle(
                    color: AppColorsLegacy.background,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDiscount, {bool isTotal = false}) {
                    final colors = context.colors;

    final w = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? w * 0.045 : w * 0.035,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? colors.textPrimary : AppColorsLegacy.textSecondary,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? w * 0.05 : w * 0.035,
            fontWeight: FontWeight.bold,
            color: isDiscount ? colors.textPrimary : (isTotal ? colors.primary : colors.textPrimary),
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCartFlow(double w, double h, double padding, List<Product> products) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          
          // Branded Glow Background for Empty Cart
          Center(
            child: SizedBox(
              width: w * 0.9,
              height: w * 0.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Top Right Purple Glow (Intensified)
                  Positioned(
                    top: -w * 0.02,
                    right: -w * 0.02,
                    child: Container(
                      width: w * 0.8,
                      height: w * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColorsLegacy.secondary.withOpacity(0.4), // Stronger purple
                            AppColorsLegacy.background.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Bottom Left Green Glow
                  Positioned(
                    bottom: -w * 0.02,
                    left: -w * 0.02,
                    child: Container(
                      width: w * 0.8,
                      height: w * 0.8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColorsLegacy.primary.withOpacity(0.25),
                            AppColorsLegacy.background.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Cart Icon Placeholder
                  Image.asset('assets/images/cart.png', width: w * 0.85),
                ],
              ),
            ),
          ),
          
          
          
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: w * 0.05,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          
          SizedBox(height: h * 0.02),

          // Primary Green Separator
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 2),
            child: Divider(
              color: AppColorsLegacy.primary.withOpacity(0.3),
              thickness: 2,
              indent: w * 0.25,
              endIndent: w * 0.25,
            ),
          ),

          SizedBox(height: h * 0.02),

          // Dummy Content Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
            child: Text(
              "Explore our top-rated restaurants and special offers to find your next favorite meal. Your cart is waiting for something delicious!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColorsLegacy.backgroundSecondary6,
                fontSize: w * 0.032,
                height: 1.6,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          
          SizedBox(height: h * 0.05),

          // "You may also like" Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "You May Also Like",
                  style: TextStyle(
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                
              ],
            ),
          ),
          
          SizedBox(height: h * 0.025),
          
          // Horizontal Product Suggestions
          SizedBox(
            height: h * 0.35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: padding),
              physics: const BouncingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildSuggestedProductCard(w, h, products[index]);
              },
            ),
          ),
          
          SizedBox(height: h * 0.05),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(double w, double h, double padding, CartItem item, CartProvider cart, {bool isStatic = false}) {
                    final colors = context.colors;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.textField,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColorsLegacy.textPrimary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              item.product.image, 
              width: w * 0.22, 
              height: w * 0.22, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: w * 0.22,
                height: w * 0.22,
                color: AppColorsLegacy.backgroundSecondary1,
                child:  Icon(Icons.fastfood, color: AppColorsLegacy.backgroundSecondary),
              ),
            ),
          ),
          SizedBox(width: w * 0.04),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: w * 0.038,
                    fontFamily: 'Montserrat',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: h * 0.005),
                
                Row(
                  children: [
                    Text(
                      "${item.product.distance} | ",
                      style: TextStyle(
                        color: AppColorsLegacy.textSecondary, 
                        fontSize: w * 0.028,
                        fontFamily: 'Montserrat'
                      ),
                    ),
                     Icon(Icons.star, size: 12, color: AppColorsLegacy.amber),
                    Text(
                      " ${item.product.rating}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: w * 0.028,
                        fontFamily: 'Montserrat'
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.01),
                
                Text(
                  "\$${item.product.price.toStringAsFixed(2)}", 
                  style: TextStyle(
                    color: AppColorsLegacy.primary, 
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.04,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity Controls or Static Display (Empty for static as requested)
          isStatic 
          ? const SizedBox.shrink()
          : Column(
              children: [
                Row(
                  children: [
                    // Minus Button
                    Material(
                      color: AppColorsLegacy.primary,
                      borderRadius: BorderRadius.circular(6),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => cart.decrementQuantity(item),
                        child: SizedBox(
                          width: w * 0.07,
                          height: w * 0.07,
                          child: Icon(Icons.remove, size: w * 0.04, color: AppColorsLegacy.background),
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: Text(
                        "${item.quantity}", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.038,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    
                    // Plus Button
                    Material(
                      color: AppColorsLegacy.primary,
                      borderRadius: BorderRadius.circular(6),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => cart.incrementQuantity(item),
                        child: SizedBox(
                          width: w * 0.07,
                          height: w * 0.07,
                          child: Icon(Icons.add, size: w * 0.04, color: AppColorsLegacy.background),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestedProductCard(double w, double h, Product offer) {
                    final colors = context.colors;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(offer: offer),
          ),
        );
      },
      child: Container(
      width: w * 0.48,
      margin: EdgeInsets.only(right: w * 0.05),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.textField,
        borderRadius: BorderRadius.circular(20),
        boxShadow:  [
          BoxShadow(
            blurRadius: 8,
            color: AppColorsLegacy.textPrimarylight12,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                offer.image,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColorsLegacy.backgroundSecondary2,
                  child:  Icon(Icons.fastfood, color: AppColorsLegacy.backgroundSecondary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          
          Text(
            offer.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: w * 0.038,
              fontFamily: 'Montserrat',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          
          Row(
            children: [
              Text(
                "${offer.distance} | ",
                style: TextStyle(
                  color: AppColorsLegacy.textSecondary, 
                  fontSize: w * 0.028,
                  fontFamily: 'Montserrat'
                ),
              ),
               Icon(Icons.star, size: 14, color: AppColorsLegacy.amber),
              Text(
                " ${offer.rating}",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: w * 0.03,
                  fontFamily: 'Montserrat'
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Text(
            "\$${offer.price.toStringAsFixed(2)}",
            style:  TextStyle(
              color: AppColorsLegacy.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),  // closes GestureDetector child: Container
    );   // closes GestureDetector
  }
}

class DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;

  const DashedDivider({
    this.height = 1,
    this.color = Colors.grey,
    this.dashWidth = 5.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (index) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
