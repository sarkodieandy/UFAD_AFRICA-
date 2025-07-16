class Supplier {
  final int id;
  final String name;
  final String contact;
  final String? createdAt;
  final String? updatedAt;

  Supplier({
    required this.id,
    required this.name,
    required this.contact,
    this.createdAt,
    this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'] ?? '',
        contact: json['contact'] ?? '',
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'contact': contact,
        if (createdAt != null) 'created_at': createdAt,
        if (updatedAt != null) 'updated_at': updatedAt,
      };
}
