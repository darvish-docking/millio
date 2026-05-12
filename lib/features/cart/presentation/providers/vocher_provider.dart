import 'package:flutter/material.dart';
import 'package:millio/features/cart/data/datasource/voucher_remote_datasource.dart';
import 'package:millio/features/cart/data/models/voucher_model.dart';



class VoucherProvider extends ChangeNotifier {
  final VoucherRemoteDatasource datasource =
      VoucherRemoteDatasource();

  List<Voucher> vouchers = [];

  Voucher? selectedVoucher;

  bool isLoading = false;

  Future<void> fetchVouchers() async {
    isLoading = true;
    notifyListeners();

    vouchers = await datasource.getVouchers();

    isLoading = false;
    notifyListeners();
  }

  void selectVoucher(Voucher voucher) {
    selectedVoucher = voucher;
    notifyListeners();
  }
}