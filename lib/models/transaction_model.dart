class Transaction {
  final String id;
  final int userId;
  final double amount;
  final String type; // 'income' or 'expense'
  final String paymentMethod;
  final String description;
  final DateTime date;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.paymentMethod,
    required this.description,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'].toString(),
    userId: int.parse(json['user_id'].toString()),
    amount: double.tryParse(json['amount'].toString()) ?? 0.0,
    type: json['type'] ?? '',
    paymentMethod: json['payment_method'] ?? '',
    description: json['description'] ?? '',
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'amount': amount,
    'type': type,
    'payment_method': paymentMethod,
    'description': description,
    'date': date.toIso8601String(),
  };
}
