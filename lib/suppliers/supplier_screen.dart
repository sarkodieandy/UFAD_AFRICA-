import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/supplier_provider.dart';
import 'package:ufad/suppliers/supplier_filter_bar.dart';
import 'package:ufad/suppliers/supplier_form.dart';
import 'package:ufad/suppliers/supplier_list.dart';
import 'package:ufad/suppliers/supplier_model.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  String? _filterCategory;
  String? _filterType;

  void _showSupplierForm({Supplier? supplier, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: SupplierForm(
          supplier: supplier,
          onSave: (newSupplier) {
            final provider = Provider.of<SupplierProvider>(context, listen: false);
            if (supplier != null && index != null) {
              provider.editSupplier(index, newSupplier);
            } else {
              provider.addSupplier(newSupplier);
            }
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final suppliers = supplierProvider.suppliers.where((s) {
      final cat = _filterCategory == null || _filterCategory == "All" || s.category == _filterCategory;
      final type = _filterType == null || _filterType == "All" || s.type == _filterType;
      return cat && type;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Supplier Management',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: Icon(Icons.account_circle, color: Colors.teal, size: 26),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 400;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Suppliers",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text("Add", style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 8 : 15, vertical: 8),
                      minimumSize: Size(10, isSmallScreen ? 36 : 40),
                    ),
                    onPressed: () => _showSupplierForm(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SupplierFilterBar(
                onCategoryChanged: (cat) => setState(() => _filterCategory = cat),
                onTypeChanged: (type) => setState(() => _filterType = type),
              ),
              const SizedBox(height: 16),
              SupplierList(
                suppliers: suppliers,
                onEdit: (supplier, idx) =>
                    _showSupplierForm(supplier: supplier, index: idx),
                onDelete: (idx) => supplierProvider.deleteSupplier(idx),
              ),
            ],
          );
        },
      ),
    );
  }
}
