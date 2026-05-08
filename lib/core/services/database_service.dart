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

  // Save Order to Firestore
  Future<void> saveOrder({
    required String uid,
    required String transactionId,
    required double totalAmount,
    required List<Map<String, dynamic>> items,
    required String status,
    String? paymentMethod,
  }) async {
    try {
      await _db.collection('orders').add({
        'userId': uid,
        'transactionId': transactionId,
        'totalAmount': totalAmount,
        'items': items,
        'status': status,
        'paymentMethod': paymentMethod,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error saving order: $e';
    }
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
