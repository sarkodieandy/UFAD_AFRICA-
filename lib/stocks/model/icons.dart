import 'package:flutter/material.dart';

IconData getCategoryIcon(String iconName) {
  switch (iconName) {
    case 'laptop':
      return Icons.laptop_mac;
    case 'car':
      return Icons.directions_car;
    // Add more mappings as needed
    default:
      return Icons.category;
  }
}
