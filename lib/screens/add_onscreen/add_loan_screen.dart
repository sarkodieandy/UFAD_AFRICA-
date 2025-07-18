// 📁 lib/screens/add_loan_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/loan_provider.dart';
import 'package:ufad/providers/auth_provider.dart';

class AddLoanScreen extends StatefulWidget {
  const AddLoanScreen({super.key});

  @override
  State<AddLoanScreen> createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _durationController = TextEditingController();
  int _loanTypeId = 1;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = context.read<AuthProvider>().user!.id;
    final loanProvider = context.read<LoanProvider>();

    try {
      await loanProvider.addLoan(
        userId: userId,
        loanTypeId: _loanTypeId,
        amount: double.parse(_amountController.text),
        duration: int.parse(_durationController.text),
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Loan submitted')));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<LoanProvider>().loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Loan'),
        backgroundColor: AppColors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: _loanTypeId,
                decoration: const InputDecoration(labelText: 'Loan Type'),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Short Term')),
                  DropdownMenuItem(value: 2, child: Text('Medium Term')),
                  DropdownMenuItem(value: 3, child: Text('Long Term')),
                ],
                onChanged: (val) => setState(() => _loanTypeId = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duration (months)',
                ),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: loading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
