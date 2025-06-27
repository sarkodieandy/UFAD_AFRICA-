import 'package:flutter/material.dart';

class PaySupplierDialog extends StatefulWidget {
  final void Function(
    String purchase,
    String account,
    String amount,
    String desc,
  )
  onPay;
  const PaySupplierDialog({super.key, required this.onPay});

  @override
  State<PaySupplierDialog> createState() => _PaySupplierDialogState();
}

class _PaySupplierDialogState extends State<PaySupplierDialog> {
  String? purchase;
  String? account;
  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Pay Supplier",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.green),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: purchase,
                decoration: const InputDecoration(
                  labelText: "Purchase",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("Select Purchase")),
                  DropdownMenuItem(
                    value: "PURCHASE_1",
                    child: Text("Purchase #1"),
                  ),
                  DropdownMenuItem(
                    value: "PURCHASE_2",
                    child: Text("Purchase #2"),
                  ),
                ],
                onChanged: (v) => setState(() => purchase = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: account,
                decoration: const InputDecoration(
                  labelText: "Account",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("Select Account")),
                  DropdownMenuItem(value: "Momo", child: Text("Momo")),
                  DropdownMenuItem(value: "Bank", child: Text("Bank")),
                ],
                onChanged: (v) => setState(() => account = v),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount (GHS)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (purchase == null ||
                            account == null ||
                            amountCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields"),
                            ),
                          );
                          return;
                        }
                        widget.onPay(
                          purchase!,
                          account!,
                          amountCtrl.text,
                          descCtrl.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Pay Supplier"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
