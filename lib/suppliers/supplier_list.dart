import 'package:flutter/material.dart';
import 'package:ufad/suppliers/supplier_model.dart';


class SupplierList extends StatelessWidget {
  final List<Supplier> suppliers;
  final Function(Supplier, int) onEdit;
  final Function(int) onDelete;

  const SupplierList({
    super.key,
    required this.suppliers,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (suppliers.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text("No suppliers found."),
      ));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: suppliers.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, idx) {
        final s = suppliers[idx];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal.shade50,
            child: Icon(Icons.local_shipping, color: Colors.teal),
          ),
          title: Text(s.name),
          subtitle: Text("${s.type} ${s.business.isNotEmpty ? "- ${s.business}" : ""} (${s.category})"),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(s, idx),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(idx),
              ),
            ],
          ),
          dense: true,
        );
      },
    );
  }
}
