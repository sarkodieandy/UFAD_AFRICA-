import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/payments_management/model/payment_transaction.dart';
import 'package:ufad/provider/payment_provider.dart';

class PaySupplierDialog extends StatefulWidget {
  const PaySupplierDialog({super.key});

  @override
  State<PaySupplierDialog> createState() => _PaySupplierDialogState();
}

class _PaySupplierDialogState extends State<PaySupplierDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _ctrl;
  late Animation<double> _scale;

  String? purchaseId;
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
    final purchases = provider.purchases;
    final accounts = provider.accounts;

    return ScaleTransition(
      scale: _scale,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Pay Supplier",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Select Purchase",
                      border: OutlineInputBorder(),
                    ),
                    value: purchaseId,
                    isExpanded: true,
                    items: purchases
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text('${p.item} (${p.supplier})'),
                            ))
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        purchaseId = v;
                        final selected = purchases.firstWhere((p) => p.id == v);
                        amount = selected.amountDue;
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty)
                        ? "Select purchase"
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Select Account",
                      border: OutlineInputBorder(),
                    ),
                    value: accountId,
                    isExpanded: true,
                    items: accounts
                        .map((a) => DropdownMenuItem(
                              value: a.id,
                              child: Text('${a.name} (${a.type})'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => accountId = v),
                    validator: (v) => (v == null || v.isEmpty)
                        ? "Select account"
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    readOnly: true,
                    key: ValueKey(amount), // refresh when changed
                    initialValue: amount.toStringAsFixed(2),
                    decoration: const InputDecoration(
                      labelText: "Amount (GHS)",
                      border: OutlineInputBorder(),
                    ),
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
                  icon: const Icon(Icons.payment_rounded),
                  label: const Text("Pay Supplier"),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final selected = purchases.firstWhere((p) => p.id == purchaseId);

                      provider.addTransaction(
                        PaymentTransaction(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          type: 'Payment',
                          account: accountId!,
                          secondaryAccount: null,
                          supplier: selected.supplier,
                          purchase: selected.item,
                          amount: amount,
                          description: description,
                          date: DateTime.now(),
                        ),
                      );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment recorded")),
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
