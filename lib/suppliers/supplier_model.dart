class Supplier {
  final String name;
  final String type; // 'Individual' or 'Business'
  final String business;
  final String category;
  final String phone;
  final String mobile;
  final String location;

  Supplier({
    required this.name,
    required this.type,
    required this.business,
    required this.category,
    required this.phone,
    required this.mobile,
    required this.location,
  });

  Supplier copyWith({
    String? name, String? type, String? business, String? category,
    String? phone, String? mobile, String? location,
  }) => Supplier(
    name: name ?? this.name,
    type: type ?? this.type,
    business: business ?? this.business,
    category: category ?? this.category,
    phone: phone ?? this.phone,
    mobile: mobile ?? this.mobile,
    location: location ?? this.location,
  );
}
