// 📁 lib/screens/sales_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/sale_provider.dart';
import 'package:ufad/screens/edit_sale_screen.dart';
import 'package:ufad/widgets/loader.dart';

class SalesListScreen extends StatelessWidget {
  const SalesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleProvider>(
      builder: (context, provider, _) {
        if (provider.loading) return const Loader();
        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        final sales = provider.sales;

        if (sales.isEmpty) {
          return const Center(child: Text('No sales recorded.'));
        }

        return ListView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            return ListTile(
              title: Text(sale.productName),
              subtitle: Text('GHS ${sale.amount.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditSaleScreen(sale: sale),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Are you sure you want to delete this sale?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(ctx, false),
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () => Navigator.pop(ctx, true),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await provider.deleteSale(sale.id);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
