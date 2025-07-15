import 'package:ufad/models/business_profile.dart';

class UserModel {
  final int id;
  final String username;
  final String email;
  final String? password;
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String gender;
  final String ageGroup;
  final String? profileImage;
  final String? nationalIdType;
  final String? userType;
  final BusinessProfile? business;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.gender,
    required this.ageGroup,
    this.profileImage,
    this.nationalIdType,
    this.userType,
    this.business,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final businesses = json['business_registrations'] as List? ?? [];

    return UserModel(
      id: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      gender: json['gender'] ?? '',
      ageGroup: json['age_group'] ?? '',
      profileImage: json['profile_image'],
      nationalIdType: json['national_id_type'],
      userType: json['user_type'],
      business: businesses.isNotEmpty && businesses.first is Map
          ? BusinessProfile.fromJson(businesses.first)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'gender': gender,
      'age_group': ageGroup,
      'profile_image': profileImage,
      'national_id_type': nationalIdType,
      'user_type': userType,
      'business': business?.toJson(),
    };
  }
}
