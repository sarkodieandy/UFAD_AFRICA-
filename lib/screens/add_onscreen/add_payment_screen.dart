import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/payment_provider.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _refController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final provider = context.read<PaymentProvider>();
      await provider.simulatePayment(
        amount: double.parse(_amountController.text),
        transactionRef: _refController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Payment simulated')));
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
    final loading = context.watch<PaymentProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulate Payment'),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _refController,
                decoration: const InputDecoration(labelText: 'Transaction Ref'),
                validator: (v) => v!.isEmpty ? 'Enter reference' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: loading ? null : _submit,
                icon: const Icon(Icons.payment),
                label: const Text('Pay'),
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
