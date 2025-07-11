import 'package:flutter/material.dart';
import 'package:ufad/payments_management/model/payment_transaction.dart';

class TransactionTable extends StatelessWidget {
  final List<PaymentTransaction> transactions;

  const TransactionTable({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Account')),
            DataColumn(label: Text('Secondary')),
            DataColumn(label: Text('Supplier')),
            DataColumn(label: Text('Purchase')),
            DataColumn(label: Text('Amount (GHS)')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Date')),
          ],
          rows: transactions.map((tx) => DataRow(
            cells: [
              DataCell(Text(tx.type)),
              DataCell(Text(tx.account)),
              DataCell(Text(tx.secondaryAccount ?? 'N/A')),
              DataCell(Text(tx.supplier ?? 'N/A')),
              DataCell(Text(tx.purchase ?? 'N/A')),
              DataCell(Text(tx.amount.toStringAsFixed(2))),
              DataCell(Text(tx.description)),
              DataCell(Text('${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')} ${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}')),
            ],
          )).toList(),
        ),
      ),
    );
  }
}
