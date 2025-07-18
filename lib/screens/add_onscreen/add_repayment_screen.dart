import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/repayment_provider.dart';

class AddRepaymentScreen extends StatefulWidget {
  const AddRepaymentScreen({super.key});

  @override
  State<AddRepaymentScreen> createState() => _AddRepaymentScreenState();
}

class _AddRepaymentScreenState extends State<AddRepaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _loanIdController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RepaymentProvider>();
    try {
      await provider.addRepayment(
        loanId: int.parse(_loanIdController.text),
        amount: double.parse(_amountController.text),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Repayment recorded')));
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
    final loading = context.watch<RepaymentProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Repayment'),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _loanIdController,
                decoration: const InputDecoration(labelText: 'Loan ID'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
