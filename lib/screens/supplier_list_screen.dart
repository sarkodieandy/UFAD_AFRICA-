import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/suppliers_provider.dart';
import 'package:ufad/widgets/loader.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        // ignore: use_build_context_synchronously
        Provider.of<SuppliersProvider>(context, listen: false).fetchSuppliers());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SuppliersProvider>(
      builder: (context, provider, _) {
        if (provider.loading) return const Loader();
        if (provider.error != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Suppliers'),
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
            ),
            body: Center(child: Text(provider.error!)),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Suppliers'),
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            onRefresh: provider.fetchSuppliers,
            child: ListView.builder(
              itemCount: provider.suppliers.length,
              itemBuilder: (context, index) {
                final supplier = provider.suppliers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(supplier.name),
                    subtitle: Text("Contact: ${supplier.contact}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit_supplier',
                              arguments: supplier,
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: Text('Delete ${supplier.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await provider.deleteSupplier(supplier.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.green,
            onPressed: () => Navigator.pushNamed(context, '/add_supplier'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
