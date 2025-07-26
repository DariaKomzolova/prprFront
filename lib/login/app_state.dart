import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState with ChangeNotifier {
  String? _role;
  String? _email;
  String? _year;

  String? get role => _role;
  String? get email => _email;
  String? get year => _year;

  Future<void> loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    _role = prefs.getString('role');
    _email = prefs.getString('email');
    _year = prefs.getString('year');
    notifyListeners();
  }

  Future<void> setUser(String role, String email, [String? year]) async {
    _role = role;
    _email = email;
    _year = year;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
    await prefs.setString('email', email);
    
    if (year != null) {
      await prefs.setString('year', year);
    } else {
      await prefs.remove('year');
    }

    notifyListeners();
  }

  Future<void> logout() async {
    _role = null;
    _email = null;
    _year = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
    await prefs.remove('email');
    await prefs.remove('year');

    notifyListeners();
  }
}
