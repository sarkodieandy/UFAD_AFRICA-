import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://ufad.ufadafrica.com/api/index.php';
  static const String authHeader = 'Basic YWRtaW46MTIzNDU2Nzg=';

  // Register user (business registration) - JSON ONLY!
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
    required String mobileNumber,
    required String gender,
    required String ageGroup,
    required String nationalIdType,
    required int regionId,
    required int districtId,
    required int townId,
    required String businessName,
    required String businessType,
    required String businessRegistered,
    required String businessSector,
    required String mainProductService,
    required int businessStartYear,
    required String businessLocation,
    required String businessPhone,
    required String estimatedWeeklySales,
    required String numberOfWorkers,
    required String recordKeepingMethod,
    required String hasInsurance,
    required String pensionScheme,
    required String bankLoan,
    required String termsAgreed,
    required String receiveUpdates,
    List<int>? supportNeeds,
  }) async {
    final Map<String, dynamic> fields = {
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'mobile_number': mobileNumber,
      'gender': gender,
      'age_group': ageGroup,
      'national_id_type': nationalIdType,
      'region_id': regionId,
      'district_id': districtId,
      'town_id': townId,
      'business_name': businessName,
      'business_type': businessType,
      'business_registered': businessRegistered,
      'business_sector': businessSector,
      'main_product_service': mainProductService,
      'business_start_year': businessStartYear,
      'business_location': businessLocation,
      'business_phone': businessPhone,
      'estimated_weekly_sales': estimatedWeeklySales,
      'number_of_workers': numberOfWorkers,
      'record_keeping_method': recordKeepingMethod,
      'has_insurance': hasInsurance,
      'pension_scheme': pensionScheme,
      'bank_loan': bankLoan,
      'terms_agreed': termsAgreed,
      'receive_updates': receiveUpdates,
    };

    // Only add support_needs if it is not null and not empty
    if (supportNeeds != null && supportNeeds.isNotEmpty) {
      fields['support_needs'] = supportNeeds;
    }

    if (kDebugMode) {
      print('[API] Register JSON fields: $fields');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );

      if (kDebugMode) {
        print('[API] Register response: ${response.statusCode} - ${response.body}');
      }

      final json = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (json['status'] == 201 || json['status'] == 200) {
          if (kDebugMode) print('[API] Registration successful!');
          return json['data'];
        }
        throw Exception(json['message'] ?? 'Unknown error');
      }
      throw Exception(json['message'] ?? 'Registration failed');
    } catch (e) {
      throw Exception('Registration API error: $e');
    }
  }

  // Login
  Future<Map<String, dynamic>> login(String login, String password) async {
    final url = '$baseUrl/login?login=$login&password=$password';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': authHeader},
      );
      final json = jsonDecode(response.body);

      if (kDebugMode) {
        print('[API] Login response: ${response.statusCode} - ${response.body}');
      }

      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Login failed');
    } catch (e) {
      throw Exception('Login API error: $e');
    }
  }
}
