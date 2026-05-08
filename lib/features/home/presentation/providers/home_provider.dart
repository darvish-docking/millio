import 'package:flutter/material.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/home/data/models/product_model.dart';

class HomeProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Product> _products = [];
  List<Product> _hotDeals = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get hotDeals => _hotDeals;
  bool get isLoading => _isLoading;

  HomeProvider() {
    _init();
  }

  void _init() {
    _isLoading = true;
    
    // Listen to all products
    _dbService.getProducts().listen((productList) {
      _products = productList;
      _isLoading = false;
      notifyListeners();
    });

    // Listen to hot deals
    _dbService.getHotDeals().listen((dealList) {
      _hotDeals = dealList;
      notifyListeners();
    });
  }
}
