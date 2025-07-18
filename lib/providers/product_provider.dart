import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final _api = ApiService();
  bool loading = false;

  Future<void> addProduct({
    required String name,
    required int quantity,
    required double price,
    required String category,
    required int supplierId,
    String? imageUrl,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _api.post('/products', {
        'product_name': name,
        'quantity': quantity,
        'unit_price': price,
        'category': category,
        'supplier_id': supplierId,
        'image_url': imageUrl ?? 'placeholder.jpg',
      });
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
