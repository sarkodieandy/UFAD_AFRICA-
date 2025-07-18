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

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    if (kDebugMode) debugPrint('🔐 Retrieved token: $token');
    return token;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
    if (kDebugMode) debugPrint('✅ Token saved.');
  }

  Future<void> clearToken() async {
    await _storage.deleteAll();
    if (kDebugMode) debugPrint('🧹 All credentials cleared.');
  }

  Future<void> saveUserId(int id) async {
    await _storage.write(key: 'user_id', value: id.toString());
    if (kDebugMode) debugPrint('👤 Saved user ID: $id');
  }

  Future<int?> getUserId() async {
    final id = await _storage.read(key: 'user_id');
    return int.tryParse(id ?? '');
  }

  Future<void> saveCredentials(String identifier, String password) async {
    await _storage.write(key: 'identifier', value: identifier);
    await _storage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> getCredentials() async {
    return {
      'identifier': await _storage.read(key: 'identifier'),
      'password': await _storage.read(key: 'password'),
    };
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: 'identifier');
    await _storage.delete(key: 'password');
  }

  Future<http.Response> get(String endpoint) => _get(endpoint);
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) =>
      _post(endpoint, data);
  Future<http.Response> put(String endpoint, Map<String, dynamic> data) =>
      _put(endpoint, data);
  Future<http.Response> delete(String endpoint) => _delete(endpoint);

  Future<http.Response> _get(String endpoint) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    try {
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
      final response = await http
          .delete(uri, headers: ApiConfig.defaultHeaders)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

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
        throw ApiException.serverError(body?['message'] ?? 'Server Error');
      default:
        throw ApiException.unknown('Unexpected error: ${res.statusCode}');
    }
  }

  Never _handleError(Object e) {
    if (e is SocketException) {
      throw ApiException.network('No internet connection');
    }
    if (e is TimeoutException) {
      throw ApiException.network('Request timed out');
    }
    throw ApiException.unknown(e.toString());
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
    await saveUserId(int.tryParse(userId.toString()) ?? 0);
    await saveCredentials(data['login'], data['password']);

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

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final res = await _post(ApiEndpoints.signup, data);
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> fetchDashboard(int userId) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiEndpoints.dashboard}?user_id=$userId',
    );
    final headers = {
      'Authorization': ApiConfig.basicAuth,
      'Content-Type': 'application/json',
    };

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));
    final handledResponse = _handleResponse(response);
    final result = jsonDecode(handledResponse.body);

    return result;
  }

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

  Future<List<dynamic>> getTransactions() async {
    final res = await _get(ApiEndpoints.transactions);
    final body = jsonDecode(res.body);
    return body is List ? body : (body['data'] ?? []);
  }

  Future<void> addTransaction(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.transactions, data);
  Future<void> updateTransaction(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.transactions}/$id', data);
  Future<void> deleteTransaction(int id) async =>
      _delete('${ApiEndpoints.transactions}/$id');

  Future<List<dynamic>> getSuppliers() async {
    final res = await _get(ApiEndpoints.suppliers);
    final body = jsonDecode(res.body);
    return body is List ? body : (body['data'] ?? []);
  }

  Future<void> addSupplier(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.suppliers, data);
  Future<void> updateSupplier(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.suppliers}/$id', data);
  Future<void> deleteSupplier(int id) async =>
      _delete('${ApiEndpoints.suppliers}/$id');

  Future<List<dynamic>> getProducts() async {
    final res = await _get(ApiEndpoints.products);
    return jsonDecode(res.body);
  }

  Future<void> addProduct(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.products, data);
  Future<void> updateProduct(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.products}/$id', data);
  Future<void> deleteProduct(int id) async =>
      _delete('${ApiEndpoints.products}/$id');

  Future<List<dynamic>> getCategories() async {
    final res = await _get(ApiEndpoints.categories);
    return jsonDecode(res.body);
  }

  Future<void> addCategory(Map<String, dynamic> data) async =>
      _post(ApiEndpoints.categories, data);
  Future<void> updateCategory(int id, Map<String, dynamic> data) async =>
      _put('${ApiEndpoints.categories}/$id', data);
  Future<void> deleteCategory(int id) async =>
      _delete('${ApiEndpoints.categories}/$id');
}
