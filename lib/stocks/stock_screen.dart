import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/stocks/providers/stock_provider.dart';
import 'package:ufad/stocks/widgets/add_stock_dialog.dart';
import 'package:ufad/stocks/widgets/stock_filters.dart';
import 'package:ufad/stocks/widgets/stock_stats.dart';
import 'package:ufad/stocks/widgets/stock_table.dart';

class StockManagementScreen extends StatelessWidget {
  const StockManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockProvider(),
      child: const StockBody(),
    );
  }
}

class StockBody extends StatelessWidget {
  const StockBody({super.key});
  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF21C087)),
          onPressed:
              () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Stock Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF21C087),
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 30),
            StockStats(stock: stock),
            const SizedBox(height: 28),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Stock Purchases',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Purchase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21C087),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      () => showDialog(
                        context: context,
                        builder: (_) => const AddStockDialog(),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const StockFilters(),
            const SizedBox(height: 12),
            const StockTable(),
          ],
        ),
      ),
    );
  }
}
