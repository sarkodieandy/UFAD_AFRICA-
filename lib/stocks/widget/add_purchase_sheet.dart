import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/stock_provider.dart';
import 'package:ufad/stocks/model/category.dart';
import 'package:ufad/stocks/model/product.dart';
import 'package:ufad/stocks/model/purchase.dart';
import 'package:ufad/stocks/model/supplier.dart';

class AddPurchaseSheet extends StatefulWidget {
  final Purchase? editPurchase;
  const AddPurchaseSheet({super.key, this.editPurchase});

  @override
  State<AddPurchaseSheet> createState() => _AddPurchaseSheetState();
}

class _AddPurchaseSheetState extends State<AddPurchaseSheet> {
  final _formKey = GlobalKey<FormState>();
  Product? _product;
  Supplier? _supplier;
  Category? _category;
  double? _unitCost;
  double? _sellingPrice;
  int? _quantity;
  String? _paymentStatus;
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    if (widget.editPurchase != null) {
      final p = widget.editPurchase!;
      _product = p.product;
      _supplier = p.supplier;
      _category = p.category;
      _unitCost = p.unitCost;
      _sellingPrice = p.sellingPrice;
      _quantity = p.quantity;
      _paymentStatus = p.paymentStatus;
      _date = p.date;
    } else {
      _paymentStatus = "Paid";
      _date = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StockProvider>(context, listen: false);
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 30,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  widget.editPurchase != null ? "Edit Purchase" : "Add Purchase",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<Product>(
                  isExpanded: true,
                  value: _product,
                  hint: const Text("Product", style: TextStyle(fontSize: 14)),
                  items: provider.products
                      .map((p) => DropdownMenuItem(value: p, child: Text(p.name, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _product = val;
                      if (val != null) {
                        _unitCost = val.costPrice;
                        _sellingPrice = val.sellingPrice;
                      }
                    });
                  },
                  validator: (v) => v == null ? "Select product" : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Supplier>(
                  isExpanded: true,
                  value: _supplier,
                  hint: const Text("Supplier", style: TextStyle(fontSize: 14)),
                  items: provider.suppliers
                      .map((s) => DropdownMenuItem(value: s, child: Text(s.name, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) => setState(() => _supplier = val),
                  validator: (v) => v == null ? "Select supplier" : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Category>(
                  isExpanded: true,
                  value: _category,
                  hint: const Text("Category", style: TextStyle(fontSize: 14)),
                  items: provider.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) => setState(() => _category = val),
                  validator: (v) => v == null ? "Select category" : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        initialValue: _unitCost?.toStringAsFixed(2) ?? '',
                        decoration: const InputDecoration(labelText: "Unit Cost", labelStyle: TextStyle(fontSize: 12)),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (v) => _unitCost = double.tryParse(v),
                        validator: (v) => (double.tryParse(v ?? "") == null) ? "Enter unit cost" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextFormField(
                        initialValue: _sellingPrice?.toStringAsFixed(2) ?? '',
                        decoration: const InputDecoration(labelText: "Selling Price", labelStyle: TextStyle(fontSize: 12)),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (v) => _sellingPrice = double.tryParse(v),
                        validator: (v) => (double.tryParse(v ?? "") == null) ? "Enter selling price" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: _quantity?.toString() ?? '',
                  decoration: const InputDecoration(labelText: "Quantity", labelStyle: TextStyle(fontSize: 12)),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 13),
                  onChanged: (v) => _quantity = int.tryParse(v),
                  validator: (v) => (int.tryParse(v ?? "") == null) ? "Enter quantity" : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _paymentStatus,
                  hint: const Text("Payment Status", style: TextStyle(fontSize: 14)),
                  items: ["Paid", "Unpaid"]
                      .map((status) => DropdownMenuItem(value: status, child: Text(status, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (val) => setState(() => _paymentStatus = val),
                  validator: (v) => v == null ? "Select payment status" : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text("Date: ", style: const TextStyle(fontSize: 13)),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date ?? DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                      child: Text(
                        _date != null ? "${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}" : "Pick Date",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel", style: TextStyle(fontSize: 13)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final margin = (_sellingPrice! - _unitCost!) / _unitCost! * 100;
                          final purchase = Purchase(
                            id: widget.editPurchase?.id ?? DateTime.now().millisecondsSinceEpoch,
                            product: _product!,
                            supplier: _supplier!,
                            category: _category!,
                            unitCost: _unitCost!,
                            sellingPrice: _sellingPrice!,
                            profitMargin: margin,
                            quantity: _quantity!,
                            totalCost: _unitCost! * _quantity!,
                            paymentStatus: _paymentStatus!,
                            date: _date!,
                          );
                          if (widget.editPurchase != null) {
                            provider.editPurchase(purchase);
                          } else {
                            provider.addPurchase(purchase);
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                widget.editPurchase != null
                                    ? 'Purchase updated!'
                                    : 'Purchase added!',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(widget.editPurchase != null ? "Update" : "Add"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
