import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/products/provider/product_provider.dart'; // Use your correct path

class EditProductDialog extends StatefulWidget {
  final int index;
  final Product product;

  const EditProductDialog({
    super.key,
    required this.index,
    required this.product,
  });

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late TextEditingController _name;
  late TextEditingController _price;
  late TextEditingController _desc;
  int? _categoryId;
  String? _categoryName;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product.name);
    _price = TextEditingController(
      text: widget.product.price.toStringAsFixed(2),
    );
    _desc = TextEditingController(text: widget.product.description);
    _categoryId = widget.product.categoryId;
    _categoryName = widget.product.category;
  }

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
                      'Edit Product',
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
                          (val) =>
                              val == null || val.trim().isEmpty
                                  ? 'Enter a name'
                                  : null,
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
                      validator:
                          (val) => val == null ? 'Select a category' : null,
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
                      validator: (val) {
                        if (val == null || val.trim().isEmpty)
                          return 'Enter price';
                        final d = double.tryParse(val);
                        if (d == null || d < 0) return 'Enter valid price';
                        return null;
                      },
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
                              if (_formKey.currentState?.validate() != true)
                                return;

                              // call updateProduct not editProduct!
                              Provider.of<ProductProvider>(
                                context,
                                listen: false,
                              ).updateProduct(
                                widget.index,
                                Product(
                                  name: _name.text.trim(),
                                  category: _categoryName!,
                                  price: double.tryParse(_price.text) ?? 0,
                                  categoryId: _categoryId!,
                                  description: _desc.text.trim(),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Update Product'),
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
