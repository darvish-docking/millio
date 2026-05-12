import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millio/features/home/data/models/product_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save User Profile to Firestore
  Future<void> saveUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'isFirstSignIn': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Error saving user profile: $e';
    }
  }

  // Get User Profile from Firestore
  Future<DocumentSnapshot> getUserProfile(String uid) async {
    try {
      return await _db.collection('users').doc(uid).get();
    } catch (e) {
      throw 'Error fetching user profile: $e';
    }
  }

  // Update User Profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error updating user profile: $e';
    }
  }

  // Save a completed order to Firestore with full cart details
  Future<String> saveOrder({
    required String uid,
    required String transactionId,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double deliveryFee,
    required double discount,
    required double totalAmount,
    required String status,
    String? paymentMethod,
    String? voucherId,
    String? voucherTitle,
    String? deliveryAddress,
    String? deliveryAddressLabel,
  }) async {
    try {
      final docRef = await _db.collection('orders').add({
        'userId': uid,
        'transactionId': transactionId,
        'items': items,
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'discount': discount,
        'totalAmount': totalAmount,
        'status': status,
        'paymentMethod': paymentMethod,
        'voucherId': voucherId,
        'voucherTitle': voucherTitle,
        'deliveryAddress': deliveryAddress,
        'deliveryAddressLabel': deliveryAddressLabel,
        'itemCount': items.length,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw 'Error saving order: $e';
    }
  }

  // Fetch all orders for a user
  Stream<List<Map<String, dynamic>>> getUserOrders(String uid) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // Get all products
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Get hot deals
  Stream<List<Product>> getHotDeals() {
    return _db
        .collection('products')
        .where('isHotDeal', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
