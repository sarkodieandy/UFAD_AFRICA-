import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/pos_provider.dart';

class PayDebtDialog extends StatefulWidget {
  const PayDebtDialog({super.key});

  @override
  State<PayDebtDialog> createState() => _PayDebtDialogState();
}

class _PayDebtDialogState extends State<PayDebtDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _ctrl;
  late Animation<double> _scale;

  String? customer;
  double amount = 0;
  String? account;
  String? paymentMethod;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 370),
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
    final provider = Provider.of<PosProvider>(context, listen: false);
    final customers = provider.customers;
    final accounts = provider.accounts;

    return ScaleTransition(
      scale: _scale,
      child: AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.money_off, color: Colors.teal, size: 23),
            const SizedBox(width: 8),
            const Text("Pay Customer Debt"),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Customer dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Customer"),
                    isExpanded: true,
                    items: customers
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(c),
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => customer = v),
                    validator: (v) => v == null || v.isEmpty ? "Select customer" : null,
                  ),
                  const SizedBox(height: 12),
                  // Amount input
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Amount (GHS)"),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => setState(() => amount = double.tryParse(v) ?? 0),
                    validator: (v) => v == null || v.isEmpty ? "Enter amount" : null,
                  ),
                  const SizedBox(height: 12),
                  // Account dropdown (wrapped for no overflow)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Account"),
                      isExpanded: true,
                      value: account,
                      items: accounts
                          .map((a) => DropdownMenuItem<String>(
                                value: a['name'] as String,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${a['name']} (GHS ${a['balance'].toStringAsFixed(2)}, ${a['type']})',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          account = v;
                          paymentMethod = accounts.firstWhere((a) => a['name'] == v)['type'].toString();
                        });
                      },
                      validator: (v) => v == null || v.isEmpty ? "Select account" : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Payment method display
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Payment Method"),
                    initialValue: paymentMethod ?? "",
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text("Pay Debt"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (customer != null && amount > 0) {
                  try {
                    provider.payDebt(customer: customer!, amount: amount);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Debt payment recorded!")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
