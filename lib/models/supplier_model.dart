class Supplier {
  final int id;
  final String name;
  final String contact;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: int.parse(json['id'].toString()),
        name: json['name'] ?? '',
        contact: json['contact'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contact': contact,
      };
}
