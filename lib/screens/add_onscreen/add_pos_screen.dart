import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/pos_provider.dart';

class AddPosScreen extends StatefulWidget {
  const AddPosScreen({super.key});

  @override
  State<AddPosScreen> createState() => _AddPosScreenState();
}

class _AddPosScreenState extends State<AddPosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerIdController = TextEditingController();
  final _accountIdController = TextEditingController();
  final _amountController = TextEditingController();

  final List<Map<String, dynamic>> _items = [];

  final _productIdController = TextEditingController();
  final _qtyController = TextEditingController();

  void _addItem() {
    final pid = _productIdController.text;
    final qty = _qtyController.text;
    if (pid.isNotEmpty && qty.isNotEmpty) {
      setState(() {
        _items.add({
          'product_id': int.parse(pid),
          'quantity': int.parse(qty),
          'discount': 0,
        });
      });
      _productIdController.clear();
      _qtyController.clear();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final provider = context.read<PosProvider>();
      await provider.createPOS(
        customerId: int.parse(_customerIdController.text),
        accountId: int.parse(_accountIdController.text),
        amount: double.parse(_amountController.text),
        items: _items,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ POS transaction created')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<PosProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add POS Transaction'),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _customerIdController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _accountIdController,
                decoration: const InputDecoration(labelText: 'Account ID'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Payment Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Items',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _productIdController,
                      decoration: const InputDecoration(
                        labelText: 'Product ID',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _qtyController,
                      decoration: const InputDecoration(labelText: 'Qty'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.green),
                    onPressed: _addItem,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._items.map(
                (item) => ListTile(
                  leading: const Icon(Icons.shopping_cart_outlined),
                  title: Text('Product ${item['product_id']}'),
                  subtitle: Text('Qty: ${item['quantity']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        _items.remove(item);
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: loading ? null : _submit,
                icon: const Icon(Icons.check_circle),
                label: const Text('Create POS'),
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
