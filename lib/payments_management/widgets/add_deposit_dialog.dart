import 'package:flutter/material.dart';

class AddDepositDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;
  const AddDepositDialog({super.key, required this.onAdd});

  @override
  State<AddDepositDialog> createState() => _AddDepositDialogState();
}

class _AddDepositDialogState extends State<AddDepositDialog> {
  String? account;
  final amount = TextEditingController();
  final description = TextEditingController();

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
                      "Add Deposit",
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
                controller: amount,
                decoration: const InputDecoration(
                  labelText: "Amount (GHS)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(0, 42),
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
                        minimumSize: const Size(0, 42),
                      ),
                      onPressed: () {
                        if (account == null || amount.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all required fields"),
                            ),
                          );
                          return;
                        }
                        widget.onAdd({
                          "type": "Deposit",
                          "account": account!,
                          "secondaryAccount": "N/A",
                          "supplier": "N/A",
                          "purchase": "N/A",
                          "amount": double.tryParse(amount.text) ?? 0,
                          "description": description.text,
                          "date": DateTime.now().toString(),
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Add Deposit"),
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
