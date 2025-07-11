class BusinessRegistration {
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
  final String? profileImageBase64;
  final String? username;

  BusinessRegistration({
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
    required this.supportNeeds,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.userType,
    this.profileImageBase64,
    this.username,
  });

  BusinessRegistration copyWith({
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
    String? profileImageBase64,
    String? username,
  }) {
    return BusinessRegistration(
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
      profileImageBase64: profileImageBase64 ?? this.profileImageBase64,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'profile_image': profileImageBase64,
      'username': username,
    };
  }
}