import 'package:flutter/material.dart';

class SupplierFilterProvider with ChangeNotifier {
  String? category;
  String? accountType;

  void setCategory(String? value) {
    category = value;
    notifyListeners();
  }

  void setAccountType(String? value) {
    accountType = value;
    notifyListeners();
  }

  void clear() {
    category = null;
    accountType = null;
    notifyListeners();
  }
}
