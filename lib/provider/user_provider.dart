// lib/providers/user_provider.dart
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = 'customer';
  String _businessName = 'bearnet';
  String _phone = '00000';
  String _location = 'KASOA';

  String get username => _username;
  String get businessName => _businessName;
  String get phone => _phone;
  String get location => _location;

  void updateProfile(String name, String phone, String location) {
    _businessName = name;
    _phone = phone;
    _location = location;
    notifyListeners();
  }

  void logout() {
    _username = '';
    _businessName = '';
    _phone = '';
    _location = '';
    notifyListeners();
  }
}