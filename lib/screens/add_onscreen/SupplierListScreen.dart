import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/models/supplier_model.dart';
import 'package:ufad/providers/SuppliersProvider.dart';
import 'package:ufad/screens/AddSupplierScreen.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<SupplierProvider>(
            context,
            listen: false,
          ).fetchSuppliers(),
    );
  }

  Future<void> _refresh() async {
    await Provider.of<SupplierProvider>(
      context,
      listen: false,
    ).fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSupplierScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Supplier'),
        backgroundColor: AppColors.green,
      ),
      body: Consumer<SupplierProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          final suppliers = provider.suppliers;

          if (suppliers.isEmpty) {
            return const Center(child: Text('No suppliers found.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: suppliers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final s = suppliers[index];
                return Dismissible(
                  key: ValueKey(s.id),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(s),
                  onDismissed: (_) async {
                    await Provider.of<SupplierProvider>(
                      context,
                      listen: false,
                    ).deleteSupplier(s.id);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.store),
                    title: Text(s.name),
                    subtitle: Text(s.phone ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _confirmDelete(Supplier supplier) {
    return showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Delete supplier "${supplier.name}"?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, false),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text('Delete'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
    );
  }
}
