import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class InventoryProvider with ChangeNotifier {
  final _api = ApiService();
  bool loading = false;

  Future<void> addInventory({
    required int categoryId,
    required String name,
    required String description,
    required double price,
    required int quantity,
    required String image,
  }) async {
    loading = true;
    notifyListeners();

    try {
      await _api.post('/inventory', {
        'category_id': categoryId,
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'image': image,
      });
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
