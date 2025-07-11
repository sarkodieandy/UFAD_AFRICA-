import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/Pos/models/pos_sale.dart';
import 'package:ufad/provider/pos_provider.dart';

class AddSaleDialog extends StatefulWidget {
  const AddSaleDialog({super.key});

  @override
  State<AddSaleDialog> createState() => _AddSaleDialogState();
}

class _AddSaleDialogState extends State<AddSaleDialog> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _ctrl;
  late Animation<double> _scale;

  String customer = "";
  double total = 0, paid = 0;

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
    return ScaleTransition(
      scale: _scale,
      child: AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.add_box_rounded, color: Colors.green, size: 23),
            const SizedBox(width: 8),
            const Text("New Sale"),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Customer",
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (v) => customer = v.trim(),
                    validator: (v) => v == null || v.isEmpty ? "Enter customer" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Total Amount (GHS)",
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => total = double.tryParse(v) ?? 0,
                    validator: (v) => v == null || v.isEmpty ? "Enter amount" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Paid (GHS)",
                      prefixIcon: Icon(Icons.payments),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) => paid = double.tryParse(v) ?? 0,
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
            icon: const Icon(Icons.save_alt),
            label: const Text("Save"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final percent = total == 0 ? 0.0 : (paid / total * 100).clamp(0, 100).toDouble();
                Provider.of<PosProvider>(context, listen: false).addSale(
                  PosSale(
                    customer: customer,
                    total: total,
                    paid: paid,
                    balance: (total - paid).clamp(0, total).toDouble(),
                    status: paid == total
                        ? "Paid"
                        : (paid == 0 ? "Unpaid" : "Partially_paid"),
                    dueDate: DateTime.now().add(const Duration(days: 7)),
                    percent: percent,
                  ),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Sale added!")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
