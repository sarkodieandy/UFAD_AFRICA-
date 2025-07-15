class Sale {
  final int id;
  final int userId;
  final double totalPayable;
  final String paymentMethod;

  Sale({
    required this.id,
    required this.userId,
    required this.totalPayable,
    required this.paymentMethod,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalPayable: (json['total_payable'] is String)
          ? double.tryParse(json['total_payable']) ?? 0.0
          : (json['total_payable'] ?? 0.0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_payable': totalPayable,
      'payment_method': paymentMethod,
    };
  }
}
