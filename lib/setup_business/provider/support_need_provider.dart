import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupportNeedProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> allSupportNeeds = [
    {"id": 1, "name": "Business registration"},
    {"id": 2, "name": "Loans / Funding"},
    {"id": 3, "name": "Record keeping"},
    {"id": 4, "name": "Market access"},
    {"id": 5, "name": "Training & coaching"},
    {"id": 6, "name": "Tax support"},
    {"id": 7, "name": "Pension / Insurance"},
  ];

  Set<int> selectedIds = {};

  void toggleSupportNeed(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    notifyListeners();
  }

  void reset() {
    selectedIds.clear();
    notifyListeners();
  }

  // POST each support need for a registration
  Future<void> submitSupportNeeds(int registrationId) async {
    for (final supportId in selectedIds) {
      final url = Uri.parse(
        "http://api.terlomarket.com/api/index.php/business_support_needs",
      );
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({
        "registration_id": registrationId,
        "support_need_id": supportId,
      });
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode != 201) {
        throw Exception("Failed to submit support need: ${response.body}");
      }
    }
  }
}
