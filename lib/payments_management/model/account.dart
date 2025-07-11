class Account {
  final String id;
  final String name;
  final String type; // "cash", "bank", "mobile_money"
  double balance;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance, required String description,
  });
}
