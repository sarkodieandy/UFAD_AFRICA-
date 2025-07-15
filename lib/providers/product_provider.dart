import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ufad/core/constants/exception.dart';
import 'package:ufad/models/product_model.dart';
import 'package:ufad/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Product> products = [];
  bool loading = false;
  String? error;

  Future<void> fetchProducts(int categoryId) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final res = await _api.get('/products?category_id=$categoryId');
      final body = jsonDecode(res.body);

      if (body['data'] is List) {
        products = List<Product>.from(
          body['data'].map((item) => Product.fromJson(item)),
        );
      } else {
        error = 'Invalid product data format';
      }
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Failed to fetch products';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
