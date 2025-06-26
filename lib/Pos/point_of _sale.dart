import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/Pos/provider/pos_provider.dart';
import 'package:ufad/Pos/widgets/NewSaleDialog.dart';
import 'widgets/pos_header.dart';
import 'widgets/pos_summary_card.dart';
import 'widgets/pos_sales_table.dart';
import 'widgets/buy_credit_dialog.dart';
import 'widgets/pay_debt_dialog.dart';
import 'widgets/pos_filters.dart';

class PointOfSaleScreen extends StatelessWidget {
  const PointOfSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => POSProvider(),
      child: const _POSBody(),
    );
  }
}

class _POSBody extends StatelessWidget {
  const _POSBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<POSProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: POSHeader(
          onBack: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Credits: ${provider.credits.toStringAsFixed(2)}',
              style: const TextStyle(color: Color(0xFF21C087), fontSize: 15),
            ),
            const SizedBox(height: 10),
            // ---- Only Buy Credit button here ----
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (_) => const BuyCreditDialog(),
                    ),
                icon: const Icon(Icons.sms, size: 18),
                label: const Text('Buy Credit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF21C087),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.person, color: Color(0xFF21C087)),
              title: const Text(
                'customer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            POSSummaryCard(title: "Total Sales", value: "GHS 38,000.00"),
            POSSummaryCard(title: "Total Profit", value: "GHS 10,500.00"),
            POSSummaryCard(title: "Total Debtors", value: "0"),
            POSSummaryCard(title: "Total Debt Owed", value: "GHS 0.00"),
            POSSummaryCard(title: "Debt Balance", value: "GHS 0.00"),
            const SizedBox(height: 16),

            // Filter section (with its own action buttons inside)
            SalesFilterSection(
              onNewSale:
                  () => showDialog(
                    context: context,
                    builder: (_) => const NewSaleDialog(),
                  ),
              onPayDebt:
                  () => showDialog(
                    context: context,
                    builder: (_) => const PayDebtDialog(),
                  ),
            ),
            const SizedBox(height: 12),
            POSSalesTable(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
