
class PosSale {
  final String customer;
  double total;
  double paid;
  double balance;
  String status;
  DateTime dueDate;
  double percent;

  PosSale({
    required this.customer,
    required this.total,
    required this.paid,
    required this.balance,
    required this.status,
    required this.dueDate,
    required this.percent,
  });
}

