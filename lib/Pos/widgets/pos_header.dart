import 'package:flutter/material.dart';

class POSHeader extends StatelessWidget {
  final VoidCallback onBack;
  const POSHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF21C087), size: 28),
        onPressed: onBack,
        tooltip: 'Back',
      ),
      title: const Text(
        'Point of Sale',
        style: TextStyle(
          color: Color(0xFF21C087),
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: false,
    );
  }
}
