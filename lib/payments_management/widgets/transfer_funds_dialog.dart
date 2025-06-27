import 'package:flutter/material.dart';

class TransferFundsDialog extends StatefulWidget {
  final void Function(String from, String to, String amount, String desc)
  onTransfer;
  const TransferFundsDialog({super.key, required this.onTransfer});

  @override
  State<TransferFundsDialog> createState() => _TransferFundsDialogState();
}

class _TransferFundsDialogState extends State<TransferFundsDialog> {
  String? fromAccount;
  String? toAccount;
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
                      "Transfer Funds",
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
                value: fromAccount,
                decoration: const InputDecoration(
                  labelText: "From Account",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("Select Account")),
                  DropdownMenuItem(value: "Momo", child: Text("Momo")),
                  DropdownMenuItem(value: "Bank", child: Text("Bank")),
                ],
                onChanged: (v) => setState(() => fromAccount = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: toAccount,
                decoration: const InputDecoration(
                  labelText: "To Account",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("Select Account")),
                  DropdownMenuItem(value: "Momo", child: Text("Momo")),
                  DropdownMenuItem(value: "Bank", child: Text("Bank")),
                ],
                onChanged: (v) => setState(() => toAccount = v),
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
                        if (fromAccount == null ||
                            toAccount == null ||
                            amountCtrl.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields"),
                            ),
                          );
                          return;
                        }
                        widget.onTransfer(
                          fromAccount!,
                          toAccount!,
                          amountCtrl.text,
                          descCtrl.text,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("Transfer"),
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
