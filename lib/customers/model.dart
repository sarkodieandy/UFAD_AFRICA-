class Customer {
  final int id;
  final String accountType; // 'individual' or 'business'
  final String name;
  final String? businessName;
  final String category;
  final String phone;
  final String mobile;
  final String location;
  final String categoryIcon;

  Customer({
    required this.id,
    required this.accountType,
    required this.name,
    this.businessName,
    required this.category,
    required this.phone,
    required this.mobile,
    required this.location,
    required this.categoryIcon,
  });
}
