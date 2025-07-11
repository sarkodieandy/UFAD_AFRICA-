import 'package:flutter/material.dart';
import 'package:ufad/products/product_categories.dart';
import 'package:ufad/products/product_model.dart';

class ProductForm extends StatefulWidget {
  final Product? initial;
  final Function(Product) onSubmit;

  const ProductForm({super.key, this.initial, required this.onSubmit});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late String _desc;
  ProductCategory? _cat;

  @override
  void initState() {
    super.initState();
    _name = widget.initial?.name ?? '';
    _price = widget.initial?.price ?? 0;
    _desc = widget.initial?.description ?? '';
    _cat = widget.initial?.category;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? Colors.grey[850] : Colors.grey[50];
    return Card(
      elevation: 7,
      shadowColor: Colors.teal.withOpacity(0.09),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.initial == null ? 'Add Product' : 'Edit Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal.shade700,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: fillColor,
                  prefixIcon: const Icon(Icons.label_important_outlined, color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  labelStyle: TextStyle(color: Colors.teal.shade900),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Enter product name' : null,
                onSaved: (v) => _name = v!,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<ProductCategory>(
                value: _cat,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  fillColor: fillColor,
                  prefixIcon: const Icon(Icons.category, color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  labelStyle: TextStyle(color: Colors.teal.shade900),
                ),
                items: allCategories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              Icon(c.icon, color: Colors.teal, size: 18),
                              const SizedBox(width: 7),
                              Text(c.name, style: const TextStyle(fontSize: 14)),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _cat = v),
                validator: (v) => v == null ? 'Choose category' : null,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 14),
              TextFormField(
                initialValue: _price != 0 ? _price.toString() : '',
                decoration: InputDecoration(
                  labelText: 'Price (GHS)',
                  filled: true,
                  fillColor: fillColor,
                  prefixIcon: const Icon(Icons.price_check, color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  labelStyle: TextStyle(color: Colors.teal.shade900),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter price';
                  final n = double.tryParse(v);
                  if (n == null || n <= 0) return 'Invalid price';
                  return null;
                },
                onSaved: (v) => _price = double.parse(v!),
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 14),
              TextFormField(
                initialValue: _desc,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: fillColor,
                  prefixIcon: const Icon(Icons.info_outline, color: Colors.teal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  labelStyle: TextStyle(color: Colors.teal.shade900),
                ),
                maxLines: 2,
                onSaved: (v) => _desc = v ?? '',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(widget.initial == null ? Icons.add_circle : Icons.save, size: 21),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          _formKey.currentState?.save();
                          widget.onSubmit(Product(
                            id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch,
                            name: _name,
                            description: _desc,
                            price: _price,
                            category: _cat!,
                          ));
                          Navigator.pop(context);
                        }
                      },
                      label: Text(widget.initial == null ? 'Add Product' : 'Update Product'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
