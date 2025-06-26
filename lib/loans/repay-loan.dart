import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Mock Provider for Repay Loan
class RepayLoanProvider extends ChangeNotifier {
  // Replace with your data/models
  double totalDebt = 6500.0;
  double paid = 3000.0;
  double balance = 3500.0;
  String deadline = "2025-07-30";

  List<Map<String, dynamic>> activeLoans = [
    {
      "product": "INVENTORY LOAN",
      "amount": 5000,
      "status": "Active",
      "due": "2025-07-15",
      "balance": 2000,
    },
    // ...add more loans
  ];

  List<Map<String, dynamic>> paymentHistory = [
    {"amount": 1000, "date": "2025-06-20", "method": "Mobile Money"},
    // ...add more payments
  ];
}

// Entry Point for Demo
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => RepayLoanProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RepayLoanScreen(),
      ),
    ),
  );
}

// Main Repay Loan Screen
class RepayLoanScreen extends StatelessWidget {
  const RepayLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RepayLoanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Repay Loan',
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
          children: [
            RepayLoanStats(
              totalDebt: provider.totalDebt,
              paid: provider.paid,
              balance: provider.balance,
              deadline: provider.deadline,
            ),
            const SizedBox(height: 20),
            RepayLoanButton(),
            const SizedBox(height: 20),
            ActiveLoansList(loans: provider.activeLoans),
            const SizedBox(height: 20),
            PaymentHistoryList(history: provider.paymentHistory),
          ],
        ),
      ),
    );
  }
}

// Repay Loan Stats Cards
class RepayLoanStats extends StatelessWidget {
  final double totalDebt, paid, balance;
  final String deadline;
  const RepayLoanStats({
    super.key,
    required this.totalDebt,
    required this.paid,
    required this.balance,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.of(context).size.width - 48) / 2;
    return Wrap(
      runSpacing: 12,
      spacing: 12,
      children: [
        StatCard(
          label: "Total Debt",
          value: "GHS ${totalDebt.toStringAsFixed(2)}",
          width: cardWidth,
        ),
        StatCard(
          label: "Paid",
          value: "GHS ${paid.toStringAsFixed(2)}",
          width: cardWidth,
        ),
        StatCard(
          label: "Balance",
          value: "GHS ${balance.toStringAsFixed(2)}",
          width: cardWidth,
        ),
        StatCard(label: "Deadline", value: deadline, width: cardWidth),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double width;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

// Repay Loan Button
class RepayLoanButton extends StatelessWidget {
  const RepayLoanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement repayment logic/dialog
      },
      icon: const Icon(Icons.payment),
      label: const Text('Repay Loan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Active Loans List
class ActiveLoansList extends StatelessWidget {
  final List<Map<String, dynamic>> loans;
  const ActiveLoansList({super.key, required this.loans});

  @override
  Widget build(BuildContext context) {
    if (loans.isEmpty) {
      return const Text(
        'No active loans.',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Active Loans",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => LoanActiveCard(loan: loans[i]),
        ),
      ],
    );
  }
}

// Single Active Loan Card
class LoanActiveCard extends StatelessWidget {
  final Map<String, dynamic> loan;
  const LoanActiveCard({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[100],
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loan["product"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  "GHS ${loan["balance"]}",
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Amount: GHS ${loan["amount"]}"),
            Text("Due: ${loan["due"]}"),
          ],
        ),
      ),
    );
  }
}

// Payment History List
class PaymentHistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  const PaymentHistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Text(
        'No payment history.',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => PaymentHistoryCard(payment: history[i]),
        ),
      ],
    );
  }
}

// Single Payment History Card
class PaymentHistoryCard extends StatelessWidget {
  final Map<String, dynamic> payment;
  const PaymentHistoryCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.payments, color: Colors.green),
        ),
        title: Text(
          "GHS ${payment["amount"]}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Date: ${payment["date"]}\nMethod: ${payment["method"]}",
        ),
      ),
    );
  }
}
