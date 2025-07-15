// 📁 lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ufad/core/constants/exception.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  // === Token Management ===
  // === Token Management ===

/// Retrieves the saved token from secure storage.
Future<String?> getToken() async {
  final token = await _storage.read(key: 'token');
  if (kDebugMode) debugPrint('🔐 Retrieved token: $token');
  return token;
}

/// Saves the token to secure storage.
Future<void> saveToken(String token) async {
  await _storage.write(key: 'token', value: token);
  if (kDebugMode) debugPrint('✅ Token saved.');
}

/// Deletes the token and user ID from secure storage.
Future<void> clearToken() async {
  await _storage.delete(key: 'token');
  await _storage.delete(key: 'user_id');
  if (kDebugMode) debugPrint('🧹 Token & user_id cleared.');
}

/// Saves user ID as a string.
Future<void> saveUserId(int id) async {
  await _storage.write(key: 'user_id', value: id.toString());
  if (kDebugMode) debugPrint('👤 Saved user ID: $id');
}

/// Retrieves user ID as int (returns null if invalid).
Future<int?> getUserId() async {
  final id = await _storage.read(key: 'user_id');
  final parsedId = int.tryParse(id ?? '');
  if (kDebugMode) debugPrint('📥 Retrieved user ID: $parsedId');
  return parsedId;
}


  // === HTTP Methods ===
  Future<http.Response> get(String endpoint) => _get(endpoint);
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) =>
      _post(endpoint, data);
  Future<http.Response> put(String endpoint, Map<String, dynamic> data) =>
      _put(endpoint, data);
  Future<http.Response> delete(String endpoint) => _delete(endpoint);

  // === Internal Wrappers ===
  Future<http.Response> _get(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    try {
      if (kDebugMode) debugPrint('[GET] $uri');
      final response = await http
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<http.Response> _post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    try {
      if (kDebugMode) debugPrint('[POST] $uri\nPayload: ${jsonEncode(data)}');
      final response = await http
          .post(uri, headers: ApiConfig.defaultHeaders, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<http.Response> _put(String endpoint, Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    try {
      if (kDebugMode) debugPrint('[PUT] $uri\nPayload: ${jsonEncode(data)}');
      final response = await http
          .put(uri, headers: ApiConfig.defaultHeaders, body: jsonEncode(data))
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<http.Response> _delete(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    try {
      if (kDebugMode) debugPrint('[DELETE] $uri');
      final response = await http
          .delete(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // === Response & Error Handling ===
  http.Response _handleResponse(http.Response res) {
    final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;
    switch (res.statusCode) {
      case 200:
      case 201:
        return res;
      case 400:
        throw ApiException.badRequest(body?['message'] ?? 'Bad Request');
      case 401:
        throw ApiException.unauthorized(body?['message'] ?? 'Unauthorized');
      case 500:
        throw ApiException.serverError(body?['message'] ?? 'Server error');
      default:
        throw ApiException.unknown('Unexpected error: ${res.statusCode}');
    }
  }

  Never _handleError(Object e) {
    if (e is SocketException) {
      throw ApiException.network('No internet connection');
    }
    if (e is TimeoutException) throw ApiException.network('Request timed out');
    throw ApiException.unknown(e.toString());
  }

  // === Authentication ===
  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final res = await _post(ApiEndpoints.signup, data);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final login = Uri.encodeComponent(data['login']);
    final password = Uri.encodeComponent(data['password']);
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiEndpoints.login}?login=$login&password=$password',
    );

    final res = await http
        .get(uri, headers: ApiConfig.defaultHeaders)
        .timeout(const Duration(seconds: 15));
    final body = jsonDecode(_handleResponse(res).body);

    final user = body['data']?['user'];
    final token = user?['token'];
    final userId = user?['user_id'];

    if (user == null || token == null || userId == null) {
      throw ApiException.badRequest("Missing user, token, or user_id.");
    }

    await saveToken(token);

    // ✅ UPDATE THIS LINE 👇
    await saveUserId(int.tryParse(userId.toString()) ?? 0);

    return {
      'status': 200,
      'message': body['message'],
      'data': {
        'token': token,
        'user': user,
        'business_registrations': body['data']['business_registrations'],
        'support_needs': body['data']['support_needs'],
      },
    };
  }

  // === Dashboard ===
  Future<Map<String, dynamic>> fetchDashboard(int userId) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiEndpoints.dashboard}?user_id=$userId',
    );
    final token = await getToken();
    final headers = {
      ...ApiConfig.defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));
    return _handleResponse(response).body.isNotEmpty
        ? jsonDecode(response.body)
        : {};
  }

  // === Resource CRUD ===

  // Sales
  Future<List<dynamic>> getSales() async {
    final res = await _get(ApiEndpoints.sales);
    final body = jsonDecode(res.body);
    return body is List ? body : (body['data'] ?? []);
  }

  Future<void> addSale(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.sales, data);
  Future<void> updateSale(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.sales}/$id', data);
  Future<void> deleteSale(int id) async => _delete('${ApiEndpoints.sales}/$id');

  // Transactions
  Future<List<dynamic>> getTransactions() async {
    final res = await _get(ApiEndpoints.transactions);
    return jsonDecode(res.body);
  }

  Future<void> addTransaction(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.transactions, data);
  Future<void> updateTransaction(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.transactions}/$id', data);
  Future<void> deleteTransaction(int id) async =>
      _delete('${ApiEndpoints.transactions}/$id');

  // Suppliers
  Future<List<dynamic>> getSuppliers() async {
    final res = await _get(ApiEndpoints.suppliers);
    return jsonDecode(res.body);
  }

  Future<void> addSupplier(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.suppliers, data);
  Future<void> updateSupplier(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.suppliers}/$id', data);
  Future<void> deleteSupplier(int id) async =>
      _delete('${ApiEndpoints.suppliers}/$id');

  // Products
  Future<List<dynamic>> getProducts() async {
    final res = await _get('/products');
    return jsonDecode(res.body);
  }

  Future<void> addProduct(Map<String, dynamic> data) async =>
      _post('/products', data);
  Future<void> updateProduct(int id, Map<String, dynamic> data) async =>
      _put('/products/$id', data);
  Future<void> deleteProduct(int id) async => _delete('/products/$id');

  // Categories
  Future<List<dynamic>> getCategories() async {
    final res = await _get('/categories');
    return jsonDecode(res.body);
  }

  Future<void> addCategory(Map<String, dynamic> data) async =>
      _post('/categories', data);
  Future<void> updateCategory(int id, Map<String, dynamic> data) async =>
      _put('/categories/$id', data);
  Future<void> deleteCategory(int id) async => _delete('/categories/$id');
}
