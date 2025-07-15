class BusinessProfile {
  final int id;
  final String name;
  final String mainProductService;

  BusinessProfile({
    required this.id,
    required this.name,
    required this.mainProductService,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? json['business_name'] ?? '',
      mainProductService: json['main_product_service'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'main_product_service': mainProductService,
    };
  }
}
