import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/pos_provider.dart';

class PosSaleTable extends StatelessWidget {
  const PosSaleTable({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<PosProvider>().sales;

    if (sales.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text("No sales yet.")),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // <-- THIS FIXES THE OVERFLOW
        child: DataTable(
          key: ValueKey(sales.length), // ensures AnimatedSwitcher triggers on change
          columns: const [
            DataColumn(label: Text('Customer')),
            DataColumn(label: Text('Total (GHS)')),
            DataColumn(label: Text('Paid (GHS)')),
            DataColumn(label: Text('Balance (GHS)')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Due Date')),
            DataColumn(label: Text('Progress')),
          ],
          rows: [
            for (final sale in sales)
              DataRow(
                key: ValueKey(sale),
                cells: [
                  DataCell(Text(sale.customer)),
                  DataCell(Text(sale.total.toStringAsFixed(2))),
                  DataCell(Text(sale.paid.toStringAsFixed(2))),
                  DataCell(Text(sale.balance.toStringAsFixed(2))),
                  DataCell(Text(sale.status)),
                  DataCell(Text(
                    "${sale.dueDate.year}-${sale.dueDate.month.toString().padLeft(2, '0')}-${sale.dueDate.day.toString().padLeft(2, '0')}",
                  )),
                  DataCell(
                    SizedBox(
                      width: 120, // Ensures progress bar doesn't overflow
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: sale.percent / 100,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade200,
                              color: sale.percent == 100 ? Colors.teal : Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("${sale.percent.toStringAsFixed(1)}%"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
