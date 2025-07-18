import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/SuppliersProvider.dart';
import 'package:ufad/providers/product_provider.dart';
import 'package:ufad/providers/category_provider.dart';

class AddProductScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const AddProductScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedSupplierId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;

    final categoryProvider = context.read<CategoryProvider>();
    final supplierProvider = context.read<SupplierProvider>();

    if (categoryProvider.categories.isEmpty) {
      categoryProvider.fetchCategories();
    }

    if (supplierProvider.suppliers.isEmpty) {
      supplierProvider.fetchSuppliers();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null || _selectedSupplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category and supplier')),
      );
      return;
    }

    final provider = context.read<ProductProvider>();

    try {
      await provider.addProduct(
        name: _nameController.text,
        quantity: int.parse(_qtyController.text),
        price: double.parse(_priceController.text),
        category: _selectedCategoryId.toString(),
        supplierId: _selectedSupplierId!,
        imageUrl: _imageUrlController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Product added')));
        Navigator.pop(context);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<ProductProvider>().loading;
    final categoryProvider = context.watch<CategoryProvider>();
    final supplierProvider = context.watch<SupplierProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: AppColors.green,
      ),
      body:
          categoryProvider.loading || supplierProvider.loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _qtyController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'Unit Price',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        items:
                            categoryProvider.categories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) => setState(() => _selectedCategoryId = val),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        validator: (v) => v == null ? 'Select category' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _selectedSupplierId,
                        items:
                            supplierProvider.suppliers
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s.id,
                                    child: Text(s.name),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (val) => setState(() => _selectedSupplierId = val),
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
                        ),
                        validator: (v) => v == null ? 'Select supplier' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL (optional)',
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: loading ? null : _submit,
                        icon: const Icon(Icons.check),
                        label: const Text('Save Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.green,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
