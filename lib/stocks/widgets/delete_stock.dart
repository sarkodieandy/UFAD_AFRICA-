import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/stocks/providers/stock_provider.dart';

class DeleteStockDialog extends StatelessWidget {
  final int index;
  const DeleteStockDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          SizedBox(width: 10),
          Text('Delete Stock?', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: const Text(
        "Are you sure you want to delete this stock record? This action cannot be undone.",
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Actually delete!
            Provider.of<StockProvider>(
              context,
              listen: false,
            ).deletePurchase(index);
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
