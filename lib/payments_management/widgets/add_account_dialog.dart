import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/payments_management/model/account.dart';
import 'package:ufad/provider/payment_provider.dart';

class AddAccountDialog extends StatefulWidget {
  const AddAccountDialog({super.key});

  @override
  State<AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _ctrl;
  late Animation<double> _scale;

  String name = '';
  String? type;
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

    return ScaleTransition(
      scale: _scale,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add New Account",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Account Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => name = v,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? "Enter account name"
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Account Type",
                      border: OutlineInputBorder(),
                    ),
                    value: type,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: "cash", child: Text("Cash")),
                      DropdownMenuItem(value: "bank", child: Text("Bank")),
                      DropdownMenuItem(value: "mobile_money", child: Text("Mobile Money")),
                    ],
                    onChanged: (v) => setState(() => type = v),
                    validator: (v) => (v == null || v.isEmpty)
                        ? "Select account type"
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Description (optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
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
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  label: const Text("Add Account"),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      provider.addAccount(
                        Account(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name.trim(),
                          type: type!,
                          balance: 0.0, description: '',
                        ),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Account added")),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}