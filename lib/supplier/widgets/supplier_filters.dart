import 'package:flutter/material.dart';

class SupplierFilters extends StatelessWidget {
  const SupplierFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        title: const Text(
          'Filters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Categories'),
                      ),
                      DropdownMenuItem(
                        value: 'Electronics',
                        child: Text('Electronics'),
                      ),
                      DropdownMenuItem(
                        value: 'Clothing',
                        child: Text('Clothing'),
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Account Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Types')),
                      DropdownMenuItem(
                        value: 'Individual',
                        child: Text('Individual'),
                      ),
                      DropdownMenuItem(
                        value: 'Business',
                        child: Text('Business'),
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
