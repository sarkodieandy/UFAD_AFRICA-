import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/location.dart';

class LocationProvider extends ChangeNotifier {
  List<Location> regions = [];
  List<Location> districts = [];
  List<Location> towns = [];

  Future<void> fetchRegions() async {
    final url = Uri.parse("http://api.terlomarket.com/api/index.php/regions");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      regions =
          (data['data'] as List).map((e) => Location.fromJson(e)).toList();
      notifyListeners();
    } else {
      throw Exception("Failed to fetch regions");
    }
  }

  // Similar for districts and towns, update URLs as needed.
}
