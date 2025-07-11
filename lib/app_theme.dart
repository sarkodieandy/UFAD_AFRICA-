import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primarySwatch: Colors.teal,
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
  fontFamily: 'Inter',
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    filled: true,
    fillColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),
);
