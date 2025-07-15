class StockPurchase {
  final int id;
  final String item;
  final int quantity;
  final double unitPrice;
  final String? date;

  StockPurchase({
    required this.id,
    required this.item,
    required this.quantity,
    required this.unitPrice,
    this.date,
  });

  factory StockPurchase.fromJson(Map<String, dynamic> json) => StockPurchase(
        id: int.parse(json['id'].toString()),
        item: json['item'],
        quantity: int.parse(json['quantity'].toString()),
        unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0.0,
        date: json['date'],
      );
}
