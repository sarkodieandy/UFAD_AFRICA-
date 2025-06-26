import 'package:flutter/material.dart';

class CustomerDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> sale;

  const CustomerDetailsDialog({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    // Dummy data for purchased items & payment history for demonstration.
    final itemsPurchased = [
      {
        'product': 'IPHONE',
        'quantity': 1,
        'unitPrice': 4000.0,
        'discount': 0.0,
      },
    ];
    final paymentHistory = [
      {
        'amount': 1800.0,
        'method': 'Mobile_money',
        'date': '2025-06-24 09:01:34',
      },
      {
        'amount': 2000.0,
        'method': 'Mobile_money',
        'date': '2025-06-24 09:00:54',
      },
      {
        'amount': 100.0,
        'method': 'Mobile_money',
        'date': '2025-06-24 09:00:21',
      },
      {
        'amount': 100.0,
        'method': 'Mobile_money',
        'date': '2025-06-24 08:58:26',
      },
    ];
    final purchaseHistory = [
      {
        'date': '2025-06-24 08:56:20',
        'amount': 18000.0,
        'status': 'Paid',
        'due': '2025-07-24',
      },
      {
        'date': '2025-06-23 22:31:54',
        'amount': 8000.0,
        'status': 'Paid',
        'due': '2025-07-23',
      },
      {
        'date': '2025-06-23 13:22:21',
        'amount': 4000.0,
        'status': 'Paid',
        'due': '2025-07-23',
      },
      {
        'date': '2025-06-23 12:43:20',
        'amount': 4000.0,
        'status': 'Paid',
        'due': '2025-07-23',
      },
      {
        'date': '2025-06-23 11:56:35',
        'amount': 4000.0,
        'status': 'Paid',
        'due': 'N/A',
      },
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 370,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Customer Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.green),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  sale["customer"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total Debt: GHS ${sale["balance"].toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Total Paid: GHS ${sale["paid"].toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Due Date: ${sale["date"] ?? ""}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Items Purchased",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 28,
                    dataRowHeight: 28,
                    columnSpacing: 18,
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Product",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Quantity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Unit Price (GHS)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Discount (GHS)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows:
                        itemsPurchased
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(e['product'].toString())),
                                  DataCell(Text(e['quantity'].toString())),
                                  DataCell(Text(e['unitPrice'].toString())),
                                  DataCell(Text(e['discount'].toString())),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Payment History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 28,
                    dataRowHeight: 28,
                    columnSpacing: 16,
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Amount (GHS)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Method",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows:
                        paymentHistory
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(e['amount'].toString())),
                                  DataCell(Text(e['method'].toString())),
                                  DataCell(Text(e['date'].toString())),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Purchase History",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 28,
                    dataRowHeight: 28,
                    columnSpacing: 15,
                    columns: const [
                      DataColumn(
                        label: Text(
                          "Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Total Amount (GHS)",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Payment Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Due Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows:
                        purchaseHistory
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(e['date'].toString())),
                                  DataCell(Text(e['amount'].toString())),
                                  DataCell(Text(e['status'].toString())),
                                  DataCell(Text(e['due'].toString())),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
