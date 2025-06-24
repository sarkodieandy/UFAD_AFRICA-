import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  Map<String, String> _localizedStrings = {};
  final Map<String, Map<String, String>> _cachedTranslations = {};

  Locale get locale => _locale;
  bool get isRtl => _locale.languageCode == 'ha';

  String tr(String key) => _localizedStrings[key] ?? key;

  Future<void> loadLanguage(String languageCode) async {
    try {
      if (_cachedTranslations.containsKey(languageCode)) {
        _localizedStrings = _cachedTranslations[languageCode]!;
      } else {
        final jsonString = await rootBundle.loadString(
          'assets/lang/$languageCode.json',
        );
        _localizedStrings = await compute(_parseJson, jsonString);
        _cachedTranslations[languageCode] = _localizedStrings;
      }
      _locale = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
      notifyListeners();
    } catch (e) {
      print('Error loading language: $e');
      _localizedStrings = {}; // Fallback
      _locale = const Locale('en');
      notifyListeners();
    }
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('language_code') ?? 'en';
    await loadLanguage(savedCode);
  }

  static Map<String, String> _parseJson(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
      throw FormatException('Invalid JSON format');
    } catch (e) {
      print('Error parsing JSON: $e');
      return {};
    }
  }
}
