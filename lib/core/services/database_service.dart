import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:millio/features/cart/data/models/address_model.dart';
import 'package:millio/features/cart/data/models/card_model.dart';
import 'package:millio/features/home/data/models/chat_message_model.dart';
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

  /// Streams reviews for a product ordered by createdAt descending.
  Stream<List<Map<String, dynamic>>> getProductReviews(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  /// Streams notifications for a user ordered by createdAt descending.
  /// Firestore path: notifications/{uid}/items/{notificationId}
  Stream<List<Map<String, dynamic>>> getNotifications(String uid) {
    return _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  /// Marks all unread notifications as read using a batch write.
  Future<void> markAllNotificationsRead(String uid) async {
    final unread = await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .where('isRead', isEqualTo: false)
        .get();

    if (unread.docs.isEmpty) return;

    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Toggles the isRead field on a single notification document.
  Future<void> toggleNotificationRead(
      String uid, String notificationId, bool currentValue) async {
    await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .doc(notificationId)
        .update({'isRead': !currentValue});
  }

  // --- Addresses ---

  Future<String> saveAddress({
    required String uid,
    required String label,
    required String fullName,
    required String country,
    required String street,
    required String city,
    required String phone,
    required String email,
    bool isDefault = false,
    double? latitude,
    double? longitude,
    String? addressId,
  }) async {
    final collection = _db.collection('users').doc(uid).collection('addresses');

    if (isDefault) {
      final batch = _db.batch();
      final existing = await collection.where('isDefault', isEqualTo: true).get();
      for (final doc in existing.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
      await batch.commit();
    }

    final data = {
      'label': label,
      'fullName': fullName,
      'country': country,
      'street': street,
      'city': city,
      'phone': phone,
      'email': email,
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (addressId != null) {
      await collection.doc(addressId).update(data);
      return addressId;
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
      final docRef = await collection.add(data);
      return docRef.id;
    }
  }

  Stream<List<Address>> getUserAddresses(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Address.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  // --- Cards ---

  Future<String> saveCard({
    required String uid,
    required String cardHolderName,
    required String lastFourDigits,
    required String cardNetwork,
    required String expiryDate,
    bool isDefault = false,
  }) async {
    final collection = _db.collection('users').doc(uid).collection('cards');

    if (isDefault) {
      final batch = _db.batch();
      final existing = await collection.where('isDefault', isEqualTo: true).get();
      for (final doc in existing.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
      await batch.commit();
    }

    final data = {
      'cardHolderName': cardHolderName,
      'lastFourDigits': lastFourDigits,
      'cardNetwork': cardNetwork,
      'expiryDate': expiryDate,
      'isDefault': isDefault,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final docRef = await collection.add(data);
    return docRef.id;
  }

  Stream<List<CardInfo>> getUserCards(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CardInfo.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> deleteCard(String uid, String cardId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(cardId)
        .delete();
  }

  // --- Chat ---

  /// Returns a chat document ID for a user (creates if needed).
  Future<String> _ensureChatDoc(String uid) async {
    final ref = _db.collection('chats').doc(uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'userId': uid,
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return uid;
  }

  /// Sends a message in the user's support chat.
  Future<void> sendMessage({
    required String uid,
    required String senderName,
    String? text,
    String? imageBase64,
  }) async {
    final chatId = await _ensureChatDoc(uid);
    final msgRef = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc();

    final data = ChatMessageModel(
      id: msgRef.id,
      text: text,
      senderId: uid,
      senderName: senderName,
      timestamp: DateTime.now(),
      imageBase64: imageBase64,
    ).toMap();

    await msgRef.set(data);

    await _db.collection('chats').doc(chatId).update({
      'lastMessage': text ?? '📷 Image',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  /// Toggles a reaction emoji on a message.
  Future<void> toggleReaction({
    required String chatId,
    required String messageId,
    required String reaction,
    required bool isAdding,
  }) async {
    final ref = _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId);

    if (isAdding) {
      await ref.update({
        'reactions': FieldValue.arrayUnion([reaction]),
      });
    } else {
      await ref.update({
        'reactions': FieldValue.arrayRemove([reaction]),
      });
    }
  }

  /// Streams messages for the user's support chat in chronological order.
  Stream<List<ChatMessageModel>> getChatMessages(String uid) {
    return _db
        .collection('chats')
        .doc(uid)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // --- Wishlist ---

  Future<void> addToWishlist(String uid, Product product) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .doc(product.id)
        .set({
      ...product.toMap(),
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromWishlist(String uid, String productId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .doc(productId)
        .delete();
  }

  Stream<List<Product>> getUserWishlist(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  /// Writes a new review and atomically updates aggregateRating + reviewCount.
  Future<void> addReview({
    required String productId,
    required String uid,
    required String userName,
    required String comment,
    required double rating,
    String profilePicture = '',
  }) async {
    final productRef = _db.collection('products').doc(productId);
    final reviewRef = productRef.collection('reviews').doc();

    await _db.runTransaction((tx) async {
      final productSnap = await tx.get(productRef);
      final data = productSnap.data() ?? {};
      // reviewCount may be a String like "(230)" in legacy product docs — handle both.
      final rawCount = data['reviewCount'];
      final currentCount = rawCount is int
          ? rawCount
          : rawCount is num
              ? rawCount.toInt()
              : 0;
      final currentRating = (data['aggregateRating'] as num?)?.toDouble() ?? 0.0;

      final newCount = currentCount + 1;
      final newRating = ((currentRating * currentCount) + rating) / newCount;

      tx.set(reviewRef, {
        'uid': uid,
        'userName': userName,
        'profilePicture': profilePicture,
        'rating': rating,
        'comment': comment,
        'likes': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      tx.update(productRef, {
        'aggregateRating': newRating,
        'reviewCount': newCount,
      });
    });
  }
}
