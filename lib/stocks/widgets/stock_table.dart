import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/stocks/providers/stock_provider.dart';
import 'package:ufad/stocks/widgets/delete_stock.dart';

// Make sure these dialogs are implemented!
import 'package:ufad/stocks/widgets/edit_stock_dialog.dart';

class StockTable extends StatelessWidget {
  const StockTable({super.key});

  @override
  Widget build(BuildContext context) {
    final stock = context.watch<StockProvider>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F6F9)),
        columns: const [
          DataColumn(label: Text('Icon')),
          DataColumn(label: Text('Product')),
          DataColumn(label: Text('Supplier')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Unit Cost (GHS)')),
          DataColumn(label: Text('Selling Price (GHS)')),
          DataColumn(label: Text('Profit Margin (%)')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Total Cost (GHS)')),
          DataColumn(label: Text('Payment Status')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List<DataRow>.generate(stock.purchases.length, (index) {
          final p = stock.purchases[index];
          return DataRow(
            cells: [
              const DataCell(
                CircleAvatar(
                  backgroundColor: Color(0xFFF0F0F0),
                  child: Icon(Icons.devices_other, color: Colors.grey),
                ),
              ),
              DataCell(Text(p["product"].toString())),
              DataCell(Text(p["supplier"].toString())),
              DataCell(Text(p["category"].toString())),
              DataCell(Text(p["unitCost"].toString())),
              DataCell(Text(p["sellingPrice"].toString())),
              DataCell(Text(p["profitMargin"].toString())),
              DataCell(Text(p["quantity"].toString())),
              DataCell(Text(p["totalCost"].toString())),
              DataCell(Text(p["paymentStatus"].toString())),
              DataCell(Text(p["date"].toString())),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => EditStockDialog(index: index, purchase: p),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => DeleteStockDialog(index: index),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
