import 'package:flutter/material.dart';
import 'package:ufad/core/constants/exception.dart';
import 'package:ufad/models/business_profile.dart';
import 'package:ufad/models/user_model.dart';
import 'package:ufad/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  UserModel? user;
  BusinessProfile? business;
  bool isAuthenticated = false;
  bool loading = false;
  String? error;

  static const Map<String, int> supportNeedMap = {
    "Financial Assistance": 1,
    "Training & Capacity Building": 2,
    "Marketing Support": 3,
    "Legal/Regulatory Assistance": 4,
    "Mentorship & Networking": 5,
  };

  List<int> _mapSupportNeeds(dynamic input) {
    if (input is! List) return [];
    return input
        .map<int>((e) {
          if (e is int) return e;
          if (e is String && supportNeedMap.containsKey(e)) {
            return supportNeedMap[e]!;
          }
          return -1;
        })
        .where((id) => id > 0)
        .toList();
  }

  Future<bool> signup(Map<String, dynamic> data) async {
    loading = true;
    notifyListeners();

    try {
      if (data.containsKey('support_needs')) {
        data['support_needs'] = _mapSupportNeeds(data['support_needs']);
      }

      final result = await _api.signup(data);

      if (result['status'] != 201 || result['data'] == null) {
        throw ApiException.badRequest(result['message'] ?? 'Signup failed.');
      }

      final userMap = result['data']['user'];
      final token = result['data']['token'];
      final userId = int.tryParse(userMap?['user_id']?.toString() ?? '');

      if (token == null || userId == null) {
        throw ApiException.badRequest("Missing token or user_id.");
      }

      await _api.saveToken(token);
      await _api.saveUserId(userId);

      // Immediate login to hydrate full user data
      final loginSuccess = await login({
        'login': data['email'] ?? data['mobile_number'],
        'password': data['password'],
      });

      return loginSuccess;
    } catch (e) {
      final msg = e.toString();

      if (msg.contains('Duplicate entry') && msg.contains('email')) {
        error = 'This email is already registered.';
      } else if (msg.contains('Duplicate entry') &&
          msg.contains('mobile_number')) {
        error = 'This phone number is already registered.';
      } else {
        error = 'Signup failed. Please check your details and try again.';
      }

      debugPrint('[AuthProvider] Full Exception: $msg');
      debugPrint('[AuthProvider] User Error Message: $error');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> login(Map<String, dynamic> data) async {
    loading = true;
    notifyListeners();

    try {
      final result = await _api.login(data);

      final token = result['data']?['token'];
      final userJson = result['data']?['user'];
      final businessList = result['data']?['business_registrations'] as List?;
      final businessJson =
          businessList != null && businessList.isNotEmpty
              ? businessList.first
              : null;

      if (token == null || userJson == null) {
        throw ApiException.badRequest(
          "Missing token or user in login response.",
        );
      }

      await _api.saveToken(token);

      // ✅ Parse and assign the user model
      user = UserModel.fromJson(userJson);
      business =
          businessJson != null ? BusinessProfile.fromJson(businessJson) : null;

      // ✅ Save user_id to storage for other features (like Add Sale)
      await _api.saveUserId(user!.id);

      isAuthenticated = true;
      error = null;
      return true;
    } catch (e) {
      error = 'Login failed. Please check your credentials.';
      debugPrint('[AuthProvider] Login error: $e');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _api.clearToken();
    user = null;
    business = null;
    isAuthenticated = false;
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final token = await _api.getToken();
    isAuthenticated = token != null;
    notifyListeners();
  }

  bool get isLoggedIn => user != null && isAuthenticated;

  void clearError() {
    error = null;
    notifyListeners();
  }
}
