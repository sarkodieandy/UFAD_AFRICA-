class Account {
  final int id;
  final String name;
  final double balance;

  Account({required this.id, required this.name, required this.balance});

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: int.parse(json['id'].toString()),
        name: json['name'],
        balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      );
}
