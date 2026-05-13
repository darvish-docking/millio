import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/home/data/models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Product> _wishlist = [];
  bool _isLoading = false;
  StreamSubscription? _subscription;

  List<Product> get wishlist => _wishlist;
  bool get isLoading => _isLoading;

  WishlistProvider() {
    _init();
  }

  void _init() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _isLoading = true;
    notifyListeners();

    _subscription = _dbService.getUserWishlist(uid).listen((items) {
      _wishlist = items;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> toggleWishlist(Product product) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    if (isInWishlist(product.id)) {
      await _dbService.removeFromWishlist(uid, product.id);
    } else {
      await _dbService.addToWishlist(uid, product);
    }
  }

  bool isInWishlist(String productId) {
    return _wishlist.any((p) => p.id == productId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
