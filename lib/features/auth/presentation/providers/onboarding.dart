import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/services/auth_service.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();
  int _currentIndex = 0;

  OnboardingProvider() {
    _init();
  }

  void _init() {
    loadUserData();
    // Listen to Firebase Auth state changes
    _authService.user.listen((User? user) async {
      if (user != null) {
        _isLoggedIn = true;
        _email = user.email ?? "";
        
        // Fetch username from Firestore
        try {
          final doc = await _dbService.getUserProfile(user.uid);
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            _username = data['username'] ?? "";
            _nickname = data['nickname'] ?? "";
            _dob = data['dob'] ?? "";
            _gender = data['gender'] ?? "";
            _region = data['region'] ?? "";
            _profilePicture = data['profilePicture'] ?? "";
          }
        } catch (e) {
          print("Error fetching profile in listener: $e");
        }

        // Initialize push notifications for this user session
        NotificationService().initialize(user.uid).catchError((_) {});
      } else {
        _isLoggedIn = false;
        _username = "";
        _email = "";
      }
      notifyListeners();
    });
  }

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }


  String _username = "";
  String _nickname = "";
  String _email = "";
  String _dob = "";
  String _region = "";
  String _gender = "";
  String _profilePicture = "";

  bool _isLoggedIn = false;
  


  String get username => _username;
  String get nickname => _nickname;
  String get email => _email;
  String get dob => _dob;
  String get region => _region;
  String get gender => _gender;
  String get profilePicture => _profilePicture;

  bool get isLoggedIn => _isLoggedIn;

  /// Load from SharedPreferences (Keeping for legacy/offline support or other preferences)
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _username = prefs.getString("username") ?? "";
    _email = prefs.getString("email") ?? "";
    _profilePicture = prefs.getString("profilePicture") ?? "";
    
    // Check Firebase current user first
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _isLoggedIn = true;
      _email = currentUser.email ?? "";

      // Also try to fetch latest profile from Firestore
      try {
        final doc = await _dbService.getUserProfile(currentUser.uid);
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          _username = data['username'] ?? _username;
          _nickname = data['nickname'] ?? _nickname;
          _dob = data['dob'] ?? _dob;
          _gender = data['gender'] ?? _gender;
          _region = data['region'] ?? _region;
          _profilePicture = data['profilePicture'] ?? _profilePicture;
        }
      } catch (e) {
        print("Error fetching profile in loadUserData: $e");
      }
    } else {
      _isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String full,
    required String nick,
    required String mail,
    required String birth,
    required String gen,
    required String reg,
    File? image,
  }) async {
    _username = full;
    _nickname = nick;
    _email = mail;
    _dob = birth;
    _gender = gen;
    _region = reg;

    if (image != null) {
      final bytes = await image.readAsBytes();
      _profilePicture = base64Encode(bytes);
    }

    // Save to Firestore if user is logged in
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await _dbService.updateUserProfile(currentUser.uid, {
          'username': full,
          'nickname': nick,
          'email': mail,
          'dob': birth,
          'gender': gen,
          'region': reg,
          'profilePicture': _profilePicture,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Also update local prefs
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("username", full);
        await prefs.setString("profilePicture", _profilePicture);
      } catch (e) {
        print("Error updating profile in Firestore: $e");
      }
    }
    
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String full,
    required String nick,
    required String mail,
    required String birth,
    required String gen,
    required String reg,
    required String loc,
    File? image,
  }) async {
    _username = full;
    _nickname = nick;
    _email = mail;
    _dob = birth;
    _gender = gen;
    _region = reg;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        if (image != null) {
          final bytes = await image.readAsBytes();
          _profilePicture = base64Encode(bytes);
        }

        await _dbService.updateUserProfile(currentUser.uid, {
          'username': full,
          'nickname': nick,
          'email': mail,
          'dob': birth,
          'gender': gen,
          'region': reg,
          'location': loc,
          'profilePicture': _profilePicture,
          'isFirstSignIn': false,
          'onboardingCompletedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Also save to local prefs
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("username", full);
        await prefs.setString("profilePicture", _profilePicture);
        await prefs.setBool("onboardingDone", true);
        await prefs.setBool("isLoggedIn", true);
      } catch (e) {
        throw 'Error completing onboarding: $e';
      }
    }
    notifyListeners();
  }
}