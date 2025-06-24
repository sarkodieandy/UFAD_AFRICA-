import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/business_registration_model.dart';

class RegistrationProvider extends ChangeNotifier {
  BusinessRegistration? _registration;
  int? _registrationId;

  BusinessRegistration? get registration => _registration;
  int? get registrationId => _registrationId;

  void setRegistration(BusinessRegistration reg) {
    _registration = reg;
    notifyListeners();
  }

  void setRegistrationId(int id) {
    _registrationId = id;
    notifyListeners();
  }

  // POST to API and update regId
  Future<void> submitRegistration() async {
    if (_registration == null) throw Exception("Registration is null");

    final Map<String, dynamic> regMap = _registration!.toJson();

    // Debugging: Print the full registration data to check types
    print('---- REGISTRATION DEBUG START ----');
    regMap.forEach((k, v) {
      print('$k (${v.runtimeType}): $v');
    });
    print('---- REGISTRATION DEBUG END ----');

    // Additional: Check for any number fields that are still String (should be int)
    final numberFields = [
      'staff_id',
      'region_id',
      'district_id',
      'town_id',
      'business_start_year',
    ];
    for (final field in numberFields) {
      if (regMap[field] != null && regMap[field] is String) {
        throw Exception(
          'Field "$field" should be int but is String: "${regMap[field]}"',
        );
      }
    }

    final url = Uri.parse(
      "http://api.terlomarket.com/api/index.php/business_registrations",
    );
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(regMap);

    final response = await http.post(url, headers: headers, body: body);

    print("API RESPONSE CODE: ${response.statusCode}");
    print("API RESPONSE BODY: ${response.body}");

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      // --- THE FIX: always parse to int ---
      final regIdRaw = data["data"]["registration_id"];
      _registrationId = int.tryParse(regIdRaw.toString());
      print(
        'Parsed registration_id: $_registrationId (${_registrationId.runtimeType})',
      );

      notifyListeners();
    } else {
      throw Exception("Failed to register business: ${response.body}");
    }
  }

  // GET from API by ID
  Future<void> fetchRegistration(int id) async {
    final url = Uri.parse(
      "http://api.terlomarket.com/api/index.php/business_registrations/$id",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        _registration = BusinessRegistration.fromJson(data['data'][0]);
        notifyListeners();
      }
    } else {
      throw Exception("Failed to fetch registration: ${response.body}");
    }
  }
}
