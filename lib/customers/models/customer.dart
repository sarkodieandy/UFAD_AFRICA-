class Customer {
  final String name;
  final String accountType;
  final String businessName;
  final String category;
  final String phone;
  final String mobile;
  final String location;

  Customer({
    required this.name,
    required this.accountType,
    required this.businessName,
    required this.category,
    required this.phone,
    required this.mobile,
    required this.location,
  });

  Customer copyWith({
    String? name,
    String? accountType,
    String? businessName,
    String? category,
    String? phone,
    String? mobile,
    String? location,
  }) {
    return Customer(
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      businessName: businessName ?? this.businessName,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      location: location ?? this.location,
    );
  }
}
