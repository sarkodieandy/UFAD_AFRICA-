import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/payments_management/model/payment_transaction.dart';
import 'package:ufad/provider/payment_provider.dart';

class AddDepositDialog extends StatefulWidget {
  const AddDepositDialog({super.key});

  @override
  State<AddDepositDialog> createState() => _AddDepositDialogState();
}

class _AddDepositDialogState extends State<AddDepositDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _ctrl;
  late Animation<double> _scale;

  String? accountId;
  double amount = 0;
  String description = '';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();

    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    final accounts = provider.accounts;

    return ScaleTransition(
      scale: _scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Deposit",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Select Account"),
                  value: accountId,
                  isExpanded: true,
                  items: accounts
                      .map((a) => DropdownMenuItem(
                            value: a.id,
                            child: Text('${a.name} (${a.type})'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => accountId = v),
                  validator: (v) => v == null || v.isEmpty ? "Choose account" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Amount (GHS)"),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (v) => setState(() => amount = double.tryParse(v) ?? 0),
                  validator: (v) =>
                      (v == null || v.isEmpty || double.tryParse(v) == null || double.parse(v) <= 0)
                          ? "Enter valid amount"
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Description (optional)"),
                  maxLines: 3,
                  onChanged: (v) => description = v,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_rounded),
                label: const Text("Add Deposit"),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    provider.addTransaction(
                      PaymentTransaction(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        type: 'Deposit',
                        account: accounts.firstWhere((a) => a.id == accountId!).name,
                        amount: amount,
                        description: description,
                        date: DateTime.now(),
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Deposit added")),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
