import 'package:flutter/material.dart';
import 'package:ufad/Pos/dialogues/Pos_sale_table.dart';
import 'package:ufad/Pos/dialogues/add_sale_dialog.dart';
import 'package:ufad/Pos/dialogues/metrics_grid.dart';
import 'package:ufad/Pos/dialogues/pos_header.dart';
import 'package:ufad/Pos/dialogues/pay_debt_dialog.dart'; // Import your dialog
import '../dialogues/filter_bar.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 500;
            return ListView(
              padding: EdgeInsets.fromLTRB(
                12,
                10,
                12,
                12 + MediaQuery.of(context).viewInsets.bottom,
              ),
              children: [
                // Header with back button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
                      tooltip: "Back to Dashboard",
                      onPressed: () => Navigator.of(context).pop(), // Change to Navigator.pushReplacement for actual dashboard navigation if needed
                    ),
                    const Expanded(child: PosHeader()),
                  ],
                ),
                const SizedBox(height: 18),
                // Metrics
                const MetricsGrid(),
                const SizedBox(height: 28),
                // Filters
                const FilterBar(),
                const SizedBox(height: 20),
                // Top bar: Title + New Sale + Pay Debt button
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sales",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text("New Sale"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => const AddSaleDialog(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.money),
                                label: const Text("Pay Debt"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => const PayDebtDialog(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sales",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: const Text("New Sale"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => const AddSaleDialog(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.money),
                                label: const Text("Pay Debt"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => const PayDebtDialog(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 14),
                // Sales Table
                const PosSaleTable(),
              ],
            );
          },
        ),
      ),
    );
  }
}
