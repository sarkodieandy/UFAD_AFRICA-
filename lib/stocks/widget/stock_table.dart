import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:ufad/provider/stock_provider.dart';
import 'package:ufad/stocks/model/icons.dart';
import 'package:ufad/stocks/widget/add_purchase_sheet.dart';

class StockTable extends StatelessWidget {
  const StockTable({super.key});

  @override
  Widget build(BuildContext context) {
    final purchases = context.watch<StockProvider>().purchases;

    if (purchases.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            "No purchases yet",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ),
      );
    }

    return Card(
      color: Colors.white.withOpacity(0.98),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: AnimationLimiter(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: purchases.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
          itemBuilder: (context, idx) {
            final p = purchases[idx];
            return AnimationConfiguration.staggeredList(
              position: idx,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                verticalOffset: 14.0,
                child: FadeInAnimation(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.teal.shade50,
                      child: Icon(getCategoryIcon(p.category.icon), color: Colors.teal, size: 25),
                    ),
                    title: Text(
                      p.product.name,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    subtitle: Text(
                      "${p.category.name} • ${p.supplier.name}\nGHS ${p.unitCost.toStringAsFixed(2)} — ${p.paymentStatus}",
                      style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                      maxLines: 2,
                    ),
                    trailing: PopupMenuButton(
                      elevation: 6,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (ctx) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Colors.teal),
                              SizedBox(width: 8),
                              Text("Edit", style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Delete", style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (val) async {
                        if (val == 'edit') {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => AddPurchaseSheet(editPurchase: p),
                          );
                        } else if (val == 'delete') {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              title: const Text('Delete Purchase?', style: TextStyle(fontSize: 16, color: Colors.red)),
                              content: Text(
                                  'Are you sure you want to delete "${p.product.name}"?',
                                  style: const TextStyle(fontSize: 13.5)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Cancel", style: TextStyle(fontSize: 13.5)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Delete", style: TextStyle(fontSize: 13.5, color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            context.read<StockProvider>().deletePurchase(p.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Purchase deleted', style: TextStyle(fontSize: 13))),
                            );
                          }
                        }
                      },
                    ),
                    isThreeLine: true,
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
