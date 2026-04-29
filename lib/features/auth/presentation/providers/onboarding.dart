import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentIndex = 0;

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

  bool _isLoggedIn = false;
  


  String get username => _username;
  String get nickname => _nickname;
  String get email => _email;
  String get dob => _dob;
  String get region => _region;
  String get gender => _gender;

  bool get isLoggedIn => _isLoggedIn;

  /// Load from SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _username = prefs.getString("username") ?? "";
    _email = prefs.getString("email") ?? "";
    
    _isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    notifyListeners();
  }



  void updateProfile({
    required String full,
    required String nick,
    required String mail,
    required String birth,
    required String gen,
    required String reg,
  }) {
    var fullName = full;
    _nickname = nick;
    _email = mail;
    _dob = birth;
    _gender = gen;
    _region = reg;

  print("Updated nick Name: $_nickname");
  print("Updated Email: $email");
  
    notifyListeners();
  }

}