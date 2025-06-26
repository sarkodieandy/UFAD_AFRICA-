import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Mock Provider for Payment Management
class PaymentProvider extends ChangeNotifier {
  String accountName = "GHS ACCOUNT";
  String accountNumber = "4587359293";
  double totalBalance = 32833.33;

  List<Map<String, dynamic>> transactions = [
    {
      "type": "Deposit",
      "amount": 5000.0,
      "date": "2025-06-25",
      "reference": "REF001",
    },
    {
      "type": "Payment",
      "amount": 2500.0,
      "date": "2025-06-24",
      "reference": "REF002",
    },
    // Add more transactions as needed
  ];
}

// Entry Point for Demo
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PaymentProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PaymentManagementScreen(),
      ),
    ),
  );
}

// Main Payment Management Screen
class PaymentManagementScreen extends StatelessWidget {
  const PaymentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[700],
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaymentAccountCard(
              name: provider.accountName,
              number: provider.accountNumber,
              balance: provider.totalBalance,
            ),
            const SizedBox(height: 20),
            PaymentActionsRow(),
            const SizedBox(height: 20),
            const PaymentFiltersSection(),
            const SizedBox(height: 20),
            PaymentTransactionList(),
          ],
        ),
      ),
    );
  }
}

// Payment Account Card
class PaymentAccountCard extends StatelessWidget {
  final String name, number;
  final double balance;
  const PaymentAccountCard({
    super.key,
    required this.name,
    required this.number,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Account: $number",
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              "Balance: GHS ${balance.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Payment Actions Row
class PaymentActionsRow extends StatelessWidget {
  const PaymentActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        PaymentActionButton(label: "Deposit", icon: Icons.add),
        PaymentActionButton(label: "Add Account", icon: Icons.account_balance),
        PaymentActionButton(label: "Pay Supplier", icon: Icons.send),
        PaymentActionButton(label: "Transfer", icon: Icons.compare_arrows),
        PaymentActionButton(label: "Expense", icon: Icons.money_off),
      ],
    );
  }
}

class PaymentActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  const PaymentActionButton({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {}, // Add logic here
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        textStyle: const TextStyle(fontSize: 14),
      ),
    );
  }
}

// Filters Section
class PaymentFiltersSection extends StatefulWidget {
  const PaymentFiltersSection({super.key});

  @override
  State<PaymentFiltersSection> createState() => _PaymentFiltersSectionState();
}

class _PaymentFiltersSectionState extends State<PaymentFiltersSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        title: const Text(
          'Filters',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (val) => setState(() => _expanded = val),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                    ),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('All Types')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Date'),
                    items: [
                      DropdownMenuItem(value: 'all', child: Text('All Dates')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Payment Transaction List
class PaymentTransactionList extends StatelessWidget {
  const PaymentTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<PaymentProvider>().transactions;
    if (transactions.isEmpty) {
      return const Text(
        'No transactions.',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Transactions",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder:
              (context, i) =>
                  PaymentTransactionCard(transaction: transactions[i]),
        ),
      ],
    );
  }
}

// Single Transaction Card
class PaymentTransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;
  const PaymentTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[50],
          child: Icon(
            transaction["type"] == "Deposit"
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: Colors.green,
          ),
        ),
        title: Text(
          "${transaction["type"]} - GHS ${transaction["amount"].toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Date: ${transaction["date"]}\nRef: ${transaction["reference"]}",
        ),
      ),
    );
  }
}
