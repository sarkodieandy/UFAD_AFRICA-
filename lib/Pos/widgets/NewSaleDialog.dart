import 'package:flutter/material.dart';

class NewSaleDialog extends StatefulWidget {
  const NewSaleDialog({super.key});

  @override
  State<NewSaleDialog> createState() => _NewSaleDialogState();
}

class _NewSaleDialogState extends State<NewSaleDialog> {
  String? selectedCustomer;
  String? selectedProduct;
  String? selectedAccount;

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController paymentAmountController = TextEditingController(
    text: "0",
  );

  // Dummy product list for demo
  final List<Map<String, dynamic>> products = [
    {"name": "IPHONE", "unitPrice": 4000.0, "profit": 200.0},
    {"name": "SAMSUNG TABLET", "unitPrice": 5000.0, "profit": 300.0},
    {"name": "MANGO", "unitPrice": 200.0, "profit": 30.0},
  ];

  // Dummy accounts
  final List<String> accounts = ["Bank A", "Momo", "Cash"];

  // Table data
  List<Map<String, dynamic>> orderItems = [];

  double get grandTotal => orderItems.fold<double>(
    0,
    (sum, item) => sum + (item['subtotal'] as double? ?? 0),
  );

  void addItem() {
    final product = products.firstWhere(
      (p) => p['name'] == selectedProduct,
      orElse: () => {},
    );
    if (product.isEmpty) return;
    final qty = int.tryParse(quantityController.text) ?? 0;
    if (qty <= 0) return;
    final unitPrice = product['unitPrice'] as double;
    final profitUnit = product['profit'] as double;
    final subtotal = qty * unitPrice;
    final totalProfit = qty * profitUnit;
    setState(() {
      orderItems.add({
        'product': product['name'],
        'quantity': qty,
        'unitPrice': unitPrice,
        'subtotal': subtotal,
        'discount': 0.0, // for simplicity
        'profit': totalProfit,
      });
      quantityController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('New Sale', style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.green),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Customer',
                  border: OutlineInputBorder(),
                ),
                value: selectedCustomer,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Select Customer (Optional)'),
                  ),
                  const DropdownMenuItem(
                    value: "SOLOMON",
                    child: Text('SOLOMON'),
                  ),
                  const DropdownMenuItem(value: "JANE", child: Text('JANE')),
                ],
                onChanged: (val) => setState(() => selectedCustomer = val),
              ),
              const SizedBox(height: 20),
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Select Product',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedProduct,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Select Product'),
                        ),
                        ...products.map(
                          (prod) => DropdownMenuItem(
                            value: prod['name'] as String,
                            child: Text(prod['name'] as String),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedProduct = val;
                          quantityController.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      controller: quantityController,
                      enabled: selectedProduct != null,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                  onPressed:
                      (selectedProduct != null &&
                              quantityController.text.isNotEmpty)
                          ? addItem
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // ORDER SUMMARY TABLE
              const Text(
                'Order Summary',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowHeight: 36,
                  columnSpacing: 18,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Product',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Unit Price (GHS)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Subtotal (GHS)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Discount (GHS)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Profit (GHS)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                  rows:
                      orderItems.isEmpty
                          ? [
                            DataRow(
                              cells: List.generate(
                                6,
                                (_) => const DataCell(Text("")),
                              ),
                            ),
                          ]
                          : orderItems
                              .map(
                                (item) => DataRow(
                                  cells: [
                                    DataCell(Text(item['product'].toString())),
                                    DataCell(Text(item['quantity'].toString())),
                                    DataCell(
                                      Text(item['unitPrice'].toString()),
                                    ),
                                    DataCell(
                                      Text(item['subtotal'].toStringAsFixed(2)),
                                    ),
                                    DataCell(Text(item['discount'].toString())),
                                    DataCell(
                                      Text(item['profit'].toStringAsFixed(2)),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                ),
              ),
              // Grand total
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Grand Total (GHS):  ${grandTotal.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Payment Details
              const Text(
                'Payment Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: paymentAmountController,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount (GHS)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Account',
                  border: OutlineInputBorder(),
                ),
                value: selectedAccount,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Select Account (Optional)'),
                  ),
                  ...accounts.map(
                    (acc) => DropdownMenuItem(value: acc, child: Text(acc)),
                  ),
                ],
                onChanged: (val) => setState(() => selectedAccount = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 110,
          height: 42,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel'),
          ),
        ),
        SizedBox(
          width: 150,
          height: 42,
          child: TextButton(
            onPressed: () {
              // TODO: Save sale logic here
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Complete Sale'),
          ),
        ),
      ],
    );
  }
}
