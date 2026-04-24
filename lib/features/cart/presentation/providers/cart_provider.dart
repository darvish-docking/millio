import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final SpecialOffer product;
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
      product: SpecialOffer.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];
  static const String _cartKey = 'user_cart_items';

  CartProvider() {
    _loadCartFromPrefs();
  }

  List<CartItem> get items => _items;

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

  void addItem(SpecialOffer product, int quantity) {
    final index = _items.indexWhere((item) => item.product.title == product.title);
    
    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    
    _saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.removeWhere((i) => i.product.title == item.product.title);
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
      _items.removeWhere((i) => i.product.title == item.product.title);
    }
    _saveCartToPrefs();
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
  double get discount => subtotal > 20 ? 4.99 : 0.00; 
  double get total => subtotal + deliveryFee - discount;

  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  void clearCart() {
    _items.clear();
    _saveCartToPrefs();
    notifyListeners();
  }
}
