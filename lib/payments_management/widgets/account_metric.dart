import 'package:flutter/material.dart';

class AccountMetric extends StatelessWidget {
  final String label;
  final String value;

  const AccountMetric({super.key, required this.label, required this.value, required bool highlight});



  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
      ),
    );
  }
}
