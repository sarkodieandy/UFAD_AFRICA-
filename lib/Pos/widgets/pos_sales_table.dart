import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/Pos/widgets/customer_detail.dart';
import '../provider/pos_provider.dart';
// <-- Import your dialog!

class POSSalesTable extends StatelessWidget {
  const POSSalesTable({super.key});

  // This function opens your details dialog.
  void showCustomerDetailsDialog(
    BuildContext context,
    Map<String, dynamic> sale,
  ) {
    showDialog(
      context: context,
      builder: (_) => CustomerDetailsDialog(sale: sale),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<POSProvider>().sales;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 28,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F6F9)),
          columns: const [
            DataColumn(
              label: Text(
                'Customer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Total Amount (GHS)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Paid (GHS)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Balance (GHS)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Payment Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Due Date',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Progress',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            DataColumn(
              label: Text(
                'Actions',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
          rows:
              sales.map((sale) {
                double progress = sale['progress'] ?? 1.0;
                return DataRow(
                  cells: [
                    DataCell(Text(sale["customer"].toString())),
                    DataCell(Text(sale["total"].toStringAsFixed(2))),
                    DataCell(Text(sale["paid"].toStringAsFixed(2))),
                    DataCell(Text(sale["balance"].toStringAsFixed(2))),
                    DataCell(Text(sale["status"] ?? "")),
                    DataCell(Text(sale["date"] ?? "")),
                    DataCell(
                      Row(
                        children: [
                          Container(
                            width: 62,
                            height: 14,
                            alignment: Alignment.centerLeft,
                            child: Stack(
                              children: [
                                Container(
                                  width: 62,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF21C087,
                                    ).withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                Container(
                                  width: 62 * progress,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF21C087),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${(progress * 100).toStringAsFixed(2)}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(
                          Icons.visibility,
                          color: Color(0xFF21C087),
                        ),
                        onPressed:
                            () => showCustomerDetailsDialog(context, sale),
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
