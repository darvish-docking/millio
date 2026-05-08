import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a profile picture to Firebase Storage and returns the download URL.
  Future<String> uploadProfilePicture(String uid, File file) async {
    try {
      // Create a reference to the location you want to upload to
      Reference ref = _storage.ref().child('profile_pictures').child('$uid.jpg');

      // Upload the file
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete and get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw 'Error uploading profile picture: $e';
    }
  }
}
