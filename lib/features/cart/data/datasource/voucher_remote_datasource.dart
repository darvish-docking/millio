import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millio/features/cart/data/models/voucher_model.dart';


class VoucherRemoteDatasource {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<List<Voucher>> getVouchers() async {
    final snapshot =
        await firestore.collection('vouchers').get();

    return snapshot.docs.map((doc) {
      return Voucher.fromMap(
        doc.data(),
        doc.id,
      );
    }).toList();
  }
}