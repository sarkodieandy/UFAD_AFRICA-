import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Mock Provider
class LoanProvider extends ChangeNotifier {
  List<Map<String, dynamic>> myLoans = [
    {
      "product": "INVENTORY LOAN",
      "amount": 5000,
      "tenure": "3 months",
      "status": "Pending",
      "date": "2025-06-24 09:00",
    },
    // Add more loans as needed
  ];
  bool hasOffers = false;
}

// Main Entry
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LoanProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ApplyLoanScreen(),
      ),
    ),
  );
}

// Main Screen
class ApplyLoanScreen extends StatelessWidget {
  const ApplyLoanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Loan', style: TextStyle(fontWeight: FontWeight.bold)),
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
            MyLoanApplications(),
            const SizedBox(height: 20),
            provider.hasOffers
                ? AvailableLoanOffers()
                : NoLoanOffersMessage(),
            const SizedBox(height: 20),
            ApplyLoanButton(),
          ],
        ),
      ),
    );
  }
}

// My Loan Applications Section
class MyLoanApplications extends StatelessWidget {
  const MyLoanApplications({super.key});

  @override
  Widget build(BuildContext context) {
    final loans = context.watch<LoanProvider>().myLoans;
    if (loans.isEmpty) {
      return const Text('No loan applications yet.',
          style: TextStyle(color: Colors.grey, fontSize: 16));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("My Applications", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: loans.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => LoanApplicationCard(loan: loans[i]),
        ),
      ],
    ); 
  }
}

// Loan Application Card
class LoanApplicationCard extends StatelessWidget {
  final Map<String, dynamic> loan;
  const LoanApplicationCard({super.key, required this.loan});

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
                  child: const Icon(Icons.account_balance, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loan["product"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Text(
                  loan["status"] ?? "",
                  style: TextStyle(
                    color: (loan["status"] == "Approved")
                        ? Colors.green
                        : (loan["status"] == "Pending")
                            ? Colors.orange
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text("Amount: GHS ${loan["amount"]}"),
            Text("Tenure: ${loan["tenure"]}"),
            Text("Applied: ${loan["date"]}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// No Loan Offers Message
class NoLoanOffersMessage extends StatelessWidget {
  const NoLoanOffersMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'No available loan offers at this time.',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// Available Loan Offers Section (placeholder)
class AvailableLoanOffers extends StatelessWidget {
  const AvailableLoanOffers({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with your offers UI
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Loan Offers Available! (UI Placeholder)',
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Apply Loan Button
class ApplyLoanButton extends StatelessWidget {
  const ApplyLoanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Add your logic here
      },
      icon: const Icon(Icons.add),
      label: const Text('Apply for Loan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
