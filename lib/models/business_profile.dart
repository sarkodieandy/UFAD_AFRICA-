class BusinessProfile {
  final int id;
  final String name;
  final String mainProductService;
  final String profileImage; // ✅ NEW

  BusinessProfile({
    required this.id,
    required this.name,
    required this.mainProductService,
    required this.profileImage, // ✅ NEW
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name'] ?? json['business_name'] ?? '',
      mainProductService: json['main_product_service'] ?? '',
      profileImage: json['profile_image'] ?? '', // ✅ NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'main_product_service': mainProductService,
      'profile_image': profileImage, // ✅ NEW
    };
  }
}
