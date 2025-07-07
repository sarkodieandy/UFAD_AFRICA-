class BusinessRegistration {
  final int? registrationId;
  final int staffId;
  final String fullName;
  final String mobileNumber;
  final String gender;
  final String ageGroup;
  final String nationalIdType;
  final String? nationalIdImage;
  final int regionId;
  final int districtId;
  final int townId;
  final String businessName;
  final String businessType;
  final String businessRegistered;
  final String? registrationDocument;
  final String businessSector;
  final String mainProductService;
  final int businessStartYear;
  final String businessLocation;
  final String? gpsAddress;
  final String businessPhone;
  final String estimatedWeeklySales;
  final String numberOfWorkers;
  final String recordKeepingMethod;
  final String? mobileMoneyNumber;
  final String hasInsurance;
  final String pensionScheme;
  final String bankLoan;
  final String termsAgreed;
  final String receiveUpdates;
  final List<int> supportNeeds;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? userType;
  final String? username;

  BusinessRegistration({
    this.registrationId,
    required this.staffId,
    required this.fullName,
    required this.mobileNumber,
    required this.gender,
    required this.ageGroup,
    required this.nationalIdType,
    this.nationalIdImage,
    required this.regionId,
    required this.districtId,
    required this.townId,
    required this.businessName,
    required this.businessType,
    required this.businessRegistered,
    this.registrationDocument,
    required this.businessSector,
    required this.mainProductService,
    required this.businessStartYear,
    required this.businessLocation,
    this.gpsAddress,
    required this.businessPhone,
    required this.estimatedWeeklySales,
    required this.numberOfWorkers,
    required this.recordKeepingMethod,
    this.mobileMoneyNumber,
    required this.hasInsurance,
    required this.pensionScheme,
    required this.bankLoan,
    required this.termsAgreed,
    required this.receiveUpdates,
    this.supportNeeds = const [],
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.userType,
    this.username,
  });

  factory BusinessRegistration.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    List<int> parseSupportNeeds(dynamic val) {
      if (val == null) return [];
      if (val is List) {
        // Handles both [1, 2, 3] and ["1", "2", "3"]
        return val.map((e) {
          if (e is int) return e;
          if (e is String) return int.tryParse(e) ?? 0;
          return 0;
        }).toList();
      }
      if (val is String && val.isNotEmpty) {
        // Handles "1,2,3"
        return val.split(',').map((e) => int.tryParse(e) ?? 0).toList();
      }
      return [];
    }

    return BusinessRegistration(
      registrationId: parseInt(json['registration_id']),
      staffId: parseInt(json['staff_id']),
      fullName: json['full_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      gender: json['gender'] ?? '',
      ageGroup: json['age_group'] ?? '',
      nationalIdType: json['national_id_type'] ?? '',
      nationalIdImage: json['national_id_image'],
      regionId: parseInt(json['region_id']),
      districtId: parseInt(json['district_id']),
      townId: parseInt(json['town_id']),
      businessName: json['business_name'] ?? '',
      businessType: json['business_type'] ?? '',
      businessRegistered: json['business_registered'] ?? '',
      registrationDocument: json['registration_document'],
      businessSector: json['business_sector'] ?? '',
      mainProductService: json['main_product_service'] ?? '',
      businessStartYear: parseInt(json['business_start_year']),
      businessLocation: json['business_location'] ?? '',
      gpsAddress: json['gps_address'],
      businessPhone: json['business_phone'] ?? '',
      estimatedWeeklySales: json['estimated_weekly_sales']?.toString() ?? '',
      numberOfWorkers: json['number_of_workers']?.toString() ?? '',
      recordKeepingMethod: json['record_keeping_method'] ?? '',
      mobileMoneyNumber: json['mobile_money_number'],
      hasInsurance: json['has_insurance'] ?? '',
      pensionScheme: json['pension_scheme'] ?? '',
      bankLoan: json['bank_loan'] ?? '',
      termsAgreed: json['terms_agreed'] ?? '',
      receiveUpdates: json['receive_updates'] ?? '',
      supportNeeds: parseSupportNeeds(json['support_needs']),
      email: json['email'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userType: json['user_type'],
      username: json['username'],
    );
  }

  BusinessRegistration copyWith({
    int? registrationId,
    int? staffId,
    String? fullName,
    String? mobileNumber,
    String? gender,
    String? ageGroup,
    String? nationalIdType,
    String? nationalIdImage,
    int? regionId,
    int? districtId,
    int? townId,
    String? businessName,
    String? businessType,
    String? businessRegistered,
    String? registrationDocument,
    String? businessSector,
    String? mainProductService,
    int? businessStartYear,
    String? businessLocation,
    String? gpsAddress,
    String? businessPhone,
    String? estimatedWeeklySales,
    String? numberOfWorkers,
    String? recordKeepingMethod,
    String? mobileMoneyNumber,
    String? hasInsurance,
    String? pensionScheme,
    String? bankLoan,
    String? termsAgreed,
    String? receiveUpdates,
    List<int>? supportNeeds,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? userType,
    String? username,
  }) {
    return BusinessRegistration(
      registrationId: registrationId ?? this.registrationId,
      staffId: staffId ?? this.staffId,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      nationalIdType: nationalIdType ?? this.nationalIdType,
      nationalIdImage: nationalIdImage ?? this.nationalIdImage,
      regionId: regionId ?? this.regionId,
      districtId: districtId ?? this.districtId,
      townId: townId ?? this.townId,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      businessRegistered: businessRegistered ?? this.businessRegistered,
      registrationDocument: registrationDocument ?? this.registrationDocument,
      businessSector: businessSector ?? this.businessSector,
      mainProductService: mainProductService ?? this.mainProductService,
      businessStartYear: businessStartYear ?? this.businessStartYear,
      businessLocation: businessLocation ?? this.businessLocation,
      gpsAddress: gpsAddress ?? this.gpsAddress,
      businessPhone: businessPhone ?? this.businessPhone,
      estimatedWeeklySales: estimatedWeeklySales ?? this.estimatedWeeklySales,
      numberOfWorkers: numberOfWorkers ?? this.numberOfWorkers,
      recordKeepingMethod: recordKeepingMethod ?? this.recordKeepingMethod,
      mobileMoneyNumber: mobileMoneyNumber ?? this.mobileMoneyNumber,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      pensionScheme: pensionScheme ?? this.pensionScheme,
      bankLoan: bankLoan ?? this.bankLoan,
      termsAgreed: termsAgreed ?? this.termsAgreed,
      receiveUpdates: receiveUpdates ?? this.receiveUpdates,
      supportNeeds: supportNeeds ?? this.supportNeeds,
      email: email ?? this.email,
      password: password ?? this.password,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toJson() => {
        'registration_id': registrationId,
        'staff_id': staffId,
        'full_name': fullName,
        'mobile_number': mobileNumber,
        'gender': gender,
        'age_group': ageGroup,
        'national_id_type': nationalIdType,
        'national_id_image': nationalIdImage,
        'region_id': regionId,
        'district_id': districtId,
        'town_id': townId,
        'business_name': businessName,
        'business_type': businessType,
        'business_registered': businessRegistered,
        'registration_document': registrationDocument,
        'business_sector': businessSector,
        'main_product_service': mainProductService,
        'business_start_year': businessStartYear,
        'business_location': businessLocation,
        'gps_address': gpsAddress,
        'business_phone': businessPhone,
        'estimated_weekly_sales': estimatedWeeklySales,
        'number_of_workers': numberOfWorkers,
        'record_keeping_method': recordKeepingMethod,
        'mobile_money_number': mobileMoneyNumber,
        'has_insurance': hasInsurance,
        'pension_scheme': pensionScheme,
        'bank_loan': bankLoan,
        'terms_agreed': termsAgreed,
        'receive_updates': receiveUpdates,
        'support_needs': supportNeeds,
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'user_type': userType,
        'username': username,
      };
}
