import 'dart:convert'; // Add this import for jsonEncode and jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  bool _isSignedIn = false;
  String _userName = '';
  String _email = '';

  bool get isSignedIn => _isSignedIn;
  String get userName => _userName;
  String get email => _email;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _isSignedIn = prefs.getBool('isSignedIn') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _email = prefs.getString('email') ?? '';
    notifyListeners();
  }

  Future<void> signIn(String username, String email) async {
    _isSignedIn = true;
    _userName = username;
    _email = email;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSignedIn', _isSignedIn);
    prefs.setString('userName', _userName);
    prefs.setString('email', _email);
  }

  Future<void> signOut() async {
    _isSignedIn = false;
    _userName = '';
    _email = '';
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> userExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(email);
  }

  Future<void> registerUser(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(email, jsonEncode({'username': username, 'password': password}));
  }

  Future<bool> validateUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(email)) {
      final user = jsonDecode(prefs.getString(email)!);
      return user['password'] == password;
    }
    return false;
  }
}
