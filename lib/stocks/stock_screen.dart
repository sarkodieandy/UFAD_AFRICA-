import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider Model
class StockProvider extends ChangeNotifier {
  double totalPaid = 30000;
  double totalUnpaid = 3500;
  double balanceToBePaid = 3500;
  double currentStockValue = 11000;

  List<Map<String, dynamic>> purchases = [
    {
      "product": "SAMSUNG TABLET",
      "supplier": "Test Supplier",
      "category": "Electronics",
      "unitCost": 5000.0,
      "sellingPrice": 6000.0,
      "profitMargin": 16.67,
      "quantity": 0,
      "totalCost": 15000.0,
      "paymentStatus": "Paid",
      "date": "2025-06-24 08:54:23",
    },
    {
      "product": "IPHONE",
      "supplier": "Test Supplier",
      "category": "Electronics",
      "unitCost": 3500.0,
      "sellingPrice": 4000.0,
      "profitMargin": 37.5,
      "quantity": 1,
      "totalCost": 3500.0,
      "paymentStatus": "Unpaid",
      "date": "2025-06-23 13:00:00",
    },
    // ...more purchases
  ];
}


// Main Screen
class StockManagementScreen extends StatelessWidget {
  const StockManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[700],
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StatsGrid(stock: stock),
            const SizedBox(height: 20),
            const FiltersSection(),
            const SizedBox(height: 20),
            AddPurchaseButton(),
            const SizedBox(height: 10),
            PurchasesList(),
          ],
        ),
      ),
    );
  }
}

// Stats Cards Grid
class StatsGrid extends StatelessWidget {
  final StockProvider stock;
  const StatsGrid({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    return Wrap(
      runSpacing: 12,
      spacing: 12,
      children: [
        StatCard(label: "Total Paid", value: "GHS ${stock.totalPaid.toStringAsFixed(2)}", width: cardWidth),
        StatCard(label: "Total Unpaid", value: "GHS ${stock.totalUnpaid.toStringAsFixed(2)}", width: cardWidth),
        StatCard(label: "Balance to be Paid", value: "GHS ${stock.balanceToBePaid.toStringAsFixed(2)}", width: cardWidth),
        StatCard(label: "Current Stock Value", value: "GHS ${stock.currentStockValue.toStringAsFixed(2)}", width: cardWidth),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double width;
  const StatCard({super.key, required this.label, required this.value, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }
}

// Filters Section
class FiltersSection extends StatefulWidget {
  const FiltersSection({super.key});

  @override
  State<FiltersSection> createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        title: const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (val) => setState(() => _expanded = val),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Categories')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Payment Status'),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Supplier'),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Suppliers')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                // Optionally add Date pickers, etc.
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Add Purchase Button
class AddPurchaseButton extends StatelessWidget {
  const AddPurchaseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {}, // Add logic
        icon: const Icon(Icons.add),
        label: const Text('Add Purchase'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

// Purchases List
class PurchasesList extends StatelessWidget {
  const PurchasesList({super.key});

  @override
  Widget build(BuildContext context) {
    final purchases = context.watch<StockProvider>().purchases;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: purchases.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) => PurchaseCard(purchase: purchases[i]),
    );
  }
}

// Single Purchase Card
class PurchaseCard extends StatelessWidget {
  final Map<String, dynamic> purchase;
  const PurchaseCard({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.devices_other, color: Colors.grey[700]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(purchase["product"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("${purchase["supplier"]} · ${purchase["category"]}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {}, // Edit logic
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {}, // Delete logic
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Unit Cost: GHS ${purchase["unitCost"]}"),
                Text("Selling: GHS ${purchase["sellingPrice"]}"),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Profit Margin: ${purchase["profitMargin"]}%"),
                Text("Qty: ${purchase["quantity"]}"),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Cost: GHS ${purchase["totalCost"]}"),
                Text(
                  purchase["paymentStatus"],
                  style: TextStyle(
                    color: purchase["paymentStatus"] == "Paid" ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text("Date: ${purchase["date"]}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
