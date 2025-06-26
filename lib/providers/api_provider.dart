import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  static const String baseUrl = "http://api.terlomarket.com/api/index.php";
  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> auditLogs = [];
  List<Map<String, dynamic>> categories = [];

  // Fetch Accounts
  Future<void> fetchAccounts() async {
    final url = Uri.parse("$baseUrl/accounts");
    final res = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      accounts = List<Map<String, dynamic>>.from(jsonDecode(res.body)["data"]);
      notifyListeners();
    }
  }

  // Add Account
  Future<void> addAccount(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/accounts");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) {
      await fetchAccounts();
    } else {
      throw Exception("Failed to add account: ${res.body}");
    }
  }

  // Fetch Audit Logs
  Future<void> fetchAuditLogs() async {
    final url = Uri.parse("$baseUrl/audit_logs");
    final res = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      auditLogs = List<Map<String, dynamic>>.from(jsonDecode(res.body)["data"]);
      notifyListeners();
    }
  }

  // Add Audit Log
  Future<void> addAuditLog(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/audit_logs");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) {
      await fetchAuditLogs();
    } else {
      throw Exception("Failed to add log: ${res.body}");
    }
  }

  // Fetch Categories
  Future<void> fetchCategories() async {
    final url = Uri.parse("$baseUrl/categories");
    final res = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (res.statusCode == 200) {
      categories = List<Map<String, dynamic>>.from(
        jsonDecode(res.body)["data"],
      );
      notifyListeners();
    }
  }

  // Add Category
  Future<void> addCategory(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/categories");
    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (res.statusCode == 201) {
      await fetchCategories();
    } else {
      throw Exception("Failed to add category: ${res.body}");
    }
  }
}
