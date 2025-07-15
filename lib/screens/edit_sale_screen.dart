import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/models/sale_model.dart';
import 'package:ufad/providers/sale_provider.dart';
import 'package:ufad/widgets/loader.dart';
import 'package:ufad/core/constants/colors.dart';

class EditSaleScreen extends StatefulWidget {
  final Sale sale;

  const EditSaleScreen({super.key, required this.sale});

  @override
  State<EditSaleScreen> createState() => _EditSaleScreenState();
}

class _EditSaleScreenState extends State<EditSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _formData['total_payable'] = widget.sale.totalPayable.toString();
    _formData['payment_method'] = widget.sale.paymentMethod;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    try {
      await context.read<SaleProvider>().updateSale(widget.sale.id, {
        'total_payable': double.parse(_formData['total_payable']),
        'payment_method': _formData['payment_method'],
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Sale'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _formData['total_payable'],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Total Payable'),
                      validator: (v) => v == null || double.tryParse(v) == null ? 'Enter a valid number' : null,
                      onSaved: (v) => _formData['total_payable'] = v,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _formData['payment_method'],
                      decoration: const InputDecoration(labelText: 'Payment Method'),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      onSaved: (v) => _formData['payment_method'] = v,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Update Sale'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
