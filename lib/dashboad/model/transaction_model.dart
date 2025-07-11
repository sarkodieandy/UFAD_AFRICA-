// lib/models/transaction.dart
class Transaction {
  final String id;
  final String description;
  final double amount;
  final String date;

  Transaction(this.id, this.description, this.amount, this.date);
}