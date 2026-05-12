import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:millio/features/home/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:millio/features/cart/data/models/voucher_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'], map['product']['id'] ?? ''),
      quantity: map['quantity'] ?? 1,
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  Voucher? _appliedVoucher;
  static const String _cartKey = 'user_cart_items';

  CartProvider() {
    _loadCartFromPrefs();
  }

  List<CartItem> get items => _items;
  Voucher? get appliedVoucher => _appliedVoucher;

  void applyVoucher(Voucher? voucher) {
    _appliedVoucher = voucher;
    
    notifyListeners();
  }

  // --- PERSISTENCE LOGIC ---
  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      _items.map((item) => item.toMap()).toList(),
    );
    await prefs.setString(_cartKey, encodedData);
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(_cartKey);
    
    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _items = decodedData.map((item) => CartItem.fromMap(item)).toList();
      notifyListeners();
    }
  }

  void addItem(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.product.id == item.product.id);
    _saveCartToPrefs();
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    _saveCartToPrefs();
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeWhere((i) => i.product.id == item.product.id);
    }
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeVoucher() {
  _appliedVoucher = null;
  notifyListeners();
}

  double get subtotal {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  double get deliveryFee => 5.00;
  
  // double get discount {
  //   if (_appliedVoucher != null) {
  //     switch (_appliedVoucher!.id) {
  //       case '1': // Free Delivery
  //         return deliveryFee;
  //       case '2': // 15% Off Total
  //         return subtotal * 0.15;
  //       case '4': // $5.00 Welcome Gift
  //         return 5.00;
  //       default:
  //         return 0.00;
  //     }
  //   }
  //   return 0.00;
  // }

  double get discount {
    
    print(_appliedVoucher?.title);

  if (_appliedVoucher == null) {
    return 0;
  }

  // Minimum order check
  if (subtotal < _appliedVoucher!.minimumOrder) {
    return 0;
  }

  switch (_appliedVoucher!.discountType) {

    case 'percentage':
      return subtotal *
          (_appliedVoucher!.discountValue / 100);

    case 'fixed':
      return _appliedVoucher!.discountValue;

    default:
      return 0;
  }
}


  double get finalDeliveryFee {
  if (_appliedVoucher?.discountType ==
      'free_delivery') {
    return 0;
  }

  return deliveryFee;
}



  // double get total {
  //   double result = subtotal + deliveryFee - discount;
  //   return result > 0 ? result : 0.0;
  // }

  double get total {

     print('DISCOUNT: $discount');
  print('DELIVERY: $finalDeliveryFee');

  final result =
      subtotal +
      finalDeliveryFee -
      discount;

  return result > 0 ? result : 0;
}


  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  void clearCart() {
    _items.clear();
    _appliedVoucher = null;
    _saveCartToPrefs();
    notifyListeners();
  }
}
