import 'package:flutter/material.dart';
import 'package:millio/features/cart/data/datasource/voucher_remote_datasource.dart';
import 'package:millio/features/cart/data/models/voucher_model.dart';



class VoucherProvider extends ChangeNotifier {
  final VoucherRemoteDatasource datasource =
      VoucherRemoteDatasource();

  List<Voucher> vouchers = [];

  Voucher? selectedVoucher;

  bool isLoading = false;

  String? errorMessage;

  Future<void> fetchVouchers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      vouchers = await datasource.getVouchers();
    } catch (e) {
      debugPrint('VoucherProvider: error fetching vouchers — $e');
      vouchers = [];
      errorMessage = 'Failed to load vouchers. Check your connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectVoucher(Voucher voucher) {
    selectedVoucher = voucher;
    notifyListeners();
  }
}
