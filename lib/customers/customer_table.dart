import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/customer_provider.dart';
import 'add_customer_sheet.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;
    return Card(
      elevation: 1,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: customers.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, idx) {
          final c = customers[idx];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: Icon(Icons.person, color: Colors.teal),
            ),
            title: Text(c.name, style: const TextStyle(fontSize: 13)),
            subtitle: Text("${c.accountType.capitalize()}${c.businessName != null && c.businessName!.isNotEmpty ? ' - ${c.businessName}' : ''}\n${c.category} • ${c.location}",
                style: const TextStyle(fontSize: 12)),
            trailing: PopupMenuButton(
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'edit', child: Text("Edit")),
                const PopupMenuItem(value: 'delete', child: Text("Delete")),
              ],
              onSelected: (val) {
                if (val == 'edit') {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddCustomerSheet(editCustomer: c),
                  );
                } else if (val == 'delete') {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Delete Customer"),
                      content: Text("Are you sure you want to delete ${c.name}?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CustomerProvider>().deleteCustomer(c.id);
                            Navigator.pop(ctx);
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            isThreeLine: true,
            dense: true,
          );
        },
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalize() => isEmpty ? "" : "${this[0].toUpperCase()}${substring(1)}";
}
