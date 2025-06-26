import 'package:flutter/material.dart';

class PayDebtDialog extends StatefulWidget {
  const PayDebtDialog({super.key});

  @override
  State<PayDebtDialog> createState() => _PayDebtDialogState();
}

class _PayDebtDialogState extends State<PayDebtDialog> {
  String? selectedCustomer;
  final TextEditingController amountController = TextEditingController();
  String? selectedAccount;
  final TextEditingController paymentMethodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Pay Customer Debt',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.green),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Customer',
                  hintText: 'Select Customer',
                  border: OutlineInputBorder(),
                ),
                value: selectedCustomer,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Select Customer')),
                  // Add real customers here
                ],
                onChanged: (val) => setState(() => selectedCustomer = val),
              ),
              const SizedBox(height: 16),

              // Amount
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (GHS)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Account Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Account',
                  hintText: 'Select Account',
                  border: OutlineInputBorder(),
                ),
                value: selectedAccount,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Select Account')),
                  // Add real accounts here
                ],
                onChanged: (val) => setState(() => selectedAccount = val),
              ),
              const SizedBox(height: 16),

              // Payment Method
              TextField(
                controller: paymentMethodController,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        SizedBox(
          width: 120,
          height: 44,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cancel'),
          ),
        ),
        SizedBox(
          width: 120,
          height: 44,
          child: TextButton(
            onPressed: () {
              // TODO: Add pay debt logic here
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pay Debt'),
          ),
        ),
      ],
    );
  }
}
