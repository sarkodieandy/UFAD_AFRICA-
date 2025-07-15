import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/transaction_provider.dart';
import 'package:ufad/widgets/loader.dart';
import 'package:ufad/core/constants/colors.dart';

class TransactionsListScreen extends StatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        if (provider.loading) return const Loader();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Transactions'),
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            onRefresh: provider.fetchTransactions,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = provider.transactions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text('₵${transaction.amount.toStringAsFixed(2)}'),
                    subtitle: Text('Type: ${transaction.type}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.deleteTransaction(int.parse(transaction.id)),
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.green,
            onPressed: () => Navigator.pushNamed(context, '/transactions/add'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
