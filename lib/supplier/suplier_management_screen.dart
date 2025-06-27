import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/supplier_provider.dart';
import 'widgets/add_supplier_dialog.dart';
import 'widgets/supplier_filters.dart';
import 'widgets/supplier_table.dart';

class SupplierManagementScreen extends StatelessWidget {
  const SupplierManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF21C087)),
          onPressed:
              () => Navigator.of(context).pushReplacementNamed('/dashboard'),
        ),
        title: const Text(
          'Supplier Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF21C087),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SupplierFilters(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Suppliers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21C087),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 46),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Supplier'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddSupplierDialog(
                            onAdd: (supplier) {
                              context.read<SupplierProvider>().addSupplier(
                                supplier,
                              );
                            },
                          ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Expanded(child: SupplierTable()),
          ],
        ),
      ),
    );
  }
}
