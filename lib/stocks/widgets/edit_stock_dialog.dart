import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/stocks/providers/stock_provider.dart';

class EditStockDialog extends StatefulWidget {
  final Map<String, dynamic> purchase;
  final int index;

  const EditStockDialog({
    super.key,
    required this.purchase,
    required this.index,
  });

  @override
  State<EditStockDialog> createState() => _EditStockDialogState();
}

class _EditStockDialogState extends State<EditStockDialog> {
  late TextEditingController _product;
  late TextEditingController _supplier;
  late TextEditingController _category;
  late TextEditingController _unitCost;
  late TextEditingController _sellingPrice;
  late TextEditingController _quantity;
  late TextEditingController _totalCost;
  late TextEditingController _profitMargin;
  late TextEditingController _date;

  String paymentStatus = "";
  String paymentAccount = "No Account (Unpaid)";
  String paymentMethod = "Select Method";
  String? dueDate;

  @override
  void initState() {
    super.initState();
    final p = widget.purchase;
    _product = TextEditingController(text: p['product'].toString());
    _supplier = TextEditingController(text: p['supplier'].toString());
    _category = TextEditingController(text: p['category'].toString());
    _unitCost = TextEditingController(text: p['unitCost'].toString());
    _sellingPrice = TextEditingController(text: p['sellingPrice'].toString());
    _quantity = TextEditingController(text: p['quantity'].toString());
    _totalCost = TextEditingController(text: p['totalCost'].toString());
    _profitMargin = TextEditingController(text: p['profitMargin'].toString());
    _date = TextEditingController(text: p['date'].toString());
    paymentStatus = p['paymentStatus'] ?? "Unpaid";
    // You can add more fields here as needed.
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 380,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Edit Stock Purchase',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF21C087)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildForm(),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21C087),
                        ),
                        onPressed: () {
                          final newPurchase = {
                            "product": _product.text,
                            "supplier": _supplier.text,
                            "category": _category.text,
                            "unitCost": double.tryParse(_unitCost.text) ?? 0,
                            "sellingPrice":
                                double.tryParse(_sellingPrice.text) ?? 0,
                            "profitMargin":
                                double.tryParse(_profitMargin.text) ?? 0,
                            "quantity": int.tryParse(_quantity.text) ?? 0,
                            "totalCost": double.tryParse(_totalCost.text) ?? 0,
                            "paymentStatus": paymentStatus,
                            "date": _date.text,
                          };
                          Provider.of<StockProvider>(
                            context,
                            listen: false,
                          ).updatePurchase(widget.index, newPurchase);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Update Purchase'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _product,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Supplier'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _supplier,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Category'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _category,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Unit Cost (GHS)'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _unitCost,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Selling Price (GHS)'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _sellingPrice,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Profit Margin (%)'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _profitMargin,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Total Quantity'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _quantity,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Total Cost (GHS)'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _totalCost,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Payment Status'),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: paymentStatus,
          items: const [
            DropdownMenuItem(value: "Paid", child: Text('Paid')),
            DropdownMenuItem(value: "Unpaid", child: Text('Unpaid')),
          ],
          onChanged: (val) => setState(() => paymentStatus = val ?? "Unpaid"),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 14),
        const Text('Date'),
        const SizedBox(height: 4),
        TextFormField(
          controller: _date,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
