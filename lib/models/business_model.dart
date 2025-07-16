class BusinessProfile {
  final int id;
  final String name;
  final String phone;
  final String location;
  final String? profileImage; // ✅ New field

  BusinessProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    this.profileImage,
  });

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['business_name'] ?? '',
      phone: json['business_phone'] ?? '',
      location: json['business_location'] ?? '',
      profileImage: json['profile_image'], // ✅ Parse image from backend
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': name,
      'business_phone': phone,
      'business_location': location,
      'profile_image': profileImage,
    };
  }
}
