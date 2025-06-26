import 'package:flutter/material.dart';

class POSActionButtons extends StatelessWidget {
  final VoidCallback onBuyCredit;
  final VoidCallback onNewSale;
  final VoidCallback onPayDebt;
  const POSActionButtons({
    super.key,
    required this.onBuyCredit,
    required this.onNewSale,
    required this.onPayDebt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.monetization_on, color: Colors.white),
            label: const Text(
              'Buy Credit',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onBuyCredit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF21C087),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('New Sale'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21C087),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: onNewSale,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.attach_money),
                label: const Text('Pay Debt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21C087),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: onPayDebt,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
