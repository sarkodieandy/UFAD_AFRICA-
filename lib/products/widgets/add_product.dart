import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/products/provider/product_provider.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();
  int? _categoryId;
  String? _categoryName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF21C087)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Name'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (v) => v == null || v.isEmpty ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Category'),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<int>(
                      value: _categoryId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 4, child: Text('Electronics')),
                        DropdownMenuItem(
                          value: 5,
                          child: Text('Food & Beverages'),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _categoryId = val;
                          _categoryName =
                              val == 4 ? 'Electronics' : 'Food & Beverages';
                        });
                      },
                      validator: (v) => v == null ? 'Select category' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Price (GHS)'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _price,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator:
                          (v) => v == null || v.isEmpty ? 'Enter price' : null,
                    ),
                    const SizedBox(height: 16),
                    const Text('Description'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: _desc,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF21C087),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final provider = Provider.of<ProductProvider>(
                                  context,
                                  listen: false,
                                );
                                provider.addProduct(
                                  Product(
                                    name: _name.text,
                                    category: _categoryName!,
                                    price: double.tryParse(_price.text) ?? 0,
                                    categoryId: _categoryId!,
                                    description: _desc.text,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add Product'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
