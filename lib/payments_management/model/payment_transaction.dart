class PaymentTransaction {
  final String id;
  final String type; // deposit, payment, transfer, expense
  final String account;
  final String? secondaryAccount;
  final String? supplier;
  final String? purchase;
  final double amount;
  final String description;
  final DateTime date;

  PaymentTransaction({
    required this.id,
    required this.type,
    required this.account,
    this.secondaryAccount,
    this.supplier,
    this.purchase,
    required this.amount,
    required this.description,
    required this.date,
  });

  // Optional: Add these for easier local db or serialization
  factory PaymentTransaction.fromMap(Map<String, dynamic> map) {
    return PaymentTransaction(
      id: map['id'] as String,
      type: map['type'] as String,
      account: map['account'] as String,
      secondaryAccount: map['secondaryAccount'] as String?,
      supplier: map['supplier'] as String?,
      purchase: map['purchase'] as String?,
      amount: (map['amount'] as num).toDouble(),
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'account': account,
      'secondaryAccount': secondaryAccount,
      'supplier': supplier,
      'purchase': purchase,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
