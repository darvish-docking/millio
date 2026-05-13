import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a profile picture to Firebase Storage and returns the download URL.
  Future<String> uploadProfilePicture(String uid, File file) async {
    try {
      Reference ref = _storage.ref().child('profile_pictures').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading profile picture: $e';
    }
  }

  /// Uploads a chat image and returns the download URL.
  Future<String> uploadChatImage(String uid, File file) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child('chat_images').child(uid).child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading chat image: $e';
    }
  }
}
