import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/screens/edit_transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../core/constants/colors.dart';
import 'add_transaction_screen.dart';
// Include this if implemented

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
    });
  }

  Future<void> _refreshTransactions() async {
    await Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.transactions.isEmpty) {
            return const Center(child: Text('No transactions available.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshTransactions,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: provider.transactions.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final txn = provider.transactions[index];
                final isIncome = txn.type == 'income';

                return ListTile(
                  title: Text(
                    '${isIncome ? '+' : '-'}₵${txn.amount.toStringAsFixed(2)}',
                    style: TextStyle(color: isIncome ? Colors.green : Colors.red),
                  ),
                  subtitle: Text('${txn.paymentMethod} • ${txn.description}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTransactionScreen(transaction: txn.toJson()),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
