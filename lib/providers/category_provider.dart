import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ufad/core/constants/exception.dart';
import 'package:ufad/models/category_model.dart';
import 'package:ufad/services/api_service.dart';

class CategoryProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Category> categories = [];
  bool loading = false;
  String? error;

  Future<void> fetchCategories() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _api.get('/categories');
      final data = jsonDecode(res.body);
      categories = List<Category>.from(
        data['data'].map((c) => Category.fromJson(c)),
      );
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Something went wrong';
    }

    loading = false;
    notifyListeners();
  }
}
