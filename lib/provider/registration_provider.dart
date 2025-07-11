import 'package:flutter/material.dart';
import 'package:ufad/services/register_api.dart'; // Or your actual ApiService path
import 'package:ufad/setup_business/models/business_registration.dart';

class RegistrationProvider with ChangeNotifier {
  BusinessRegistration? _registration;
  int? _userId;
  String? _token;

  BusinessRegistration? get registration => _registration;
  int? get userId => _userId;
  String? get token => _token;

  final ApiService _apiService = ApiService();

  // Dashboard state
  Map<String, dynamic>? dashboardMetrics;
  Map<String, dynamic>? dashboardBusinessProfile;
  Map<String, dynamic>? dashboardSalesTrend;
  bool dashboardLoading = false;
  String? dashboardError;

  // Set partial or full registration data
  void setRegistration(BusinessRegistration registration) {
    _registration = registration;
    debugPrint(
      '[RegistrationProvider] Registration set: ${registration.toJson()}',
    );
    notifyListeners();
  }

  // Store user data (from OwnerInfoScreen) without immediate API call
  Future<void> registerUserAndCustomer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String userType,
    required String mobileNumber,
    required String gender,
    required String ageGroup,
    required String nationalIdType,
    required int regionId,
    required int districtId,
    required int townId,
    String? profileImageBase64,
    String? nationalIdImage, // Not sent to API, local use only
    // Business fields (optional for partial registration)
    String? businessName,
    String? businessType,
    String? businessRegistered,
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
  }) async {
    _registration = BusinessRegistration(
      staffId: 0,
      fullName: '$firstName $lastName',
      mobileNumber: mobileNumber,
      gender: gender,
      ageGroup: ageGroup,
      nationalIdType: nationalIdType,
      nationalIdImage: nationalIdImage,
      regionId: regionId,
      districtId: districtId,
      townId: townId,
      businessName: businessName ?? '',
      businessType: businessType ?? '',
      businessRegistered: businessRegistered ?? '',
      registrationDocument: null,
      businessSector: businessSector ?? '',
      mainProductService: mainProductService ?? '',
      businessStartYear: businessStartYear ?? DateTime.now().year,
      businessLocation: businessLocation ?? '',
      gpsAddress: gpsAddress,
      businessPhone: businessPhone ?? '',
      estimatedWeeklySales: estimatedWeeklySales ?? '',
      numberOfWorkers: numberOfWorkers ?? '',
      recordKeepingMethod: recordKeepingMethod ?? '',
      mobileMoneyNumber: mobileMoneyNumber,
      hasInsurance: hasInsurance ?? '',
      pensionScheme: pensionScheme ?? '',
      bankLoan: bankLoan ?? '',
      termsAgreed: termsAgreed ?? '',
      receiveUpdates: receiveUpdates ?? '',
      supportNeeds: supportNeeds ?? [],
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      userType: userType,
      profileImageBase64: profileImageBase64,
      username:
          email.contains('@') ? email.split('@')[0] : '$firstName$lastName',
    );
    debugPrint(
      '[RegistrationProvider] User data staged: ${_registration!.toJson()}',
    );
    notifyListeners();
  }

  // Complete registration with all required fields (called from ConsentScreen)
  Future<void> submitRegistration() async {
    final r = _registration;
    if (r == null) {
      debugPrint('[RegistrationProvider] ERROR: Registration data not set.');
      throw Exception('Registration data not set.');
    }

    // Validate required fields
    final requiredFields = [
      r.username,
      r.email,
      r.password,
      r.firstName,
      r.lastName,
      r.mobileNumber,
      r.regionId.toString(),
      r.districtId.toString(),
      r.townId.toString(),
      r.fullName,
      r.gender,
      r.ageGroup,
      r.nationalIdType,
      r.businessName,
      r.businessType,
      r.businessRegistered,
      r.businessSector,
      r.mainProductService,
      r.businessStartYear.toString(),
      r.businessLocation,
      r.businessPhone,
      r.estimatedWeeklySales,
      r.numberOfWorkers,
      r.recordKeepingMethod,
      r.hasInsurance,
      r.pensionScheme,
      r.bankLoan,
      r.termsAgreed,
      r.receiveUpdates,
    ];

    if (requiredFields.any((field) => field == null || (field.isEmpty))) {
      debugPrint(
        '[RegistrationProvider] ERROR: Missing required registration fields.',
      );
      throw Exception('Missing required registration fields.');
    }

    debugPrint('[RegistrationProvider] Sending registration:');
    debugPrint(r.toJson().toString());

    try {
      final result = await _apiService.registerUser(
        username: r.username!,
        email: r.email!,
        password: r.password!,
        firstName: r.firstName!,
        lastName: r.lastName!,
        mobileNumber: r.mobileNumber,
        regionId: r.regionId,
        districtId: r.districtId,
        townId: r.townId,
        profileImageBase64: r.profileImageBase64,
        fullName: r.fullName,
        gender: r.gender,
        ageGroup: r.ageGroup,
        nationalIdType: r.nationalIdType,
        businessName: r.businessName,
        businessType: r.businessType,
        businessRegistered: r.businessRegistered,
        businessSector: r.businessSector,
        mainProductService: r.mainProductService,
        businessStartYear: r.businessStartYear,
        businessLocation: r.businessLocation,
        gpsAddress: r.gpsAddress,
        businessPhone: r.businessPhone,
        estimatedWeeklySales: r.estimatedWeeklySales,
        numberOfWorkers: r.numberOfWorkers,
        recordKeepingMethod: r.recordKeepingMethod,
        mobileMoneyNumber: r.mobileMoneyNumber,
        hasInsurance: r.hasInsurance,
        pensionScheme: r.pensionScheme,
        bankLoan: r.bankLoan,
        termsAgreed: r.termsAgreed,
        receiveUpdates: r.receiveUpdates,
        supportNeeds: r.supportNeeds,
      );
      debugPrint('[RegistrationProvider] Registration result: $result');
      _userId =
          result['user_id'] is int
              ? result['user_id']
              : int.tryParse(result['user_id']?.toString() ?? '');
      _token = result['token']?.toString();
      notifyListeners();
    } catch (e, st) {
      debugPrint('[RegistrationProvider] Registration failed: $e');
      debugPrint('Stack trace:\n$st');
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> login(String loginValue, String password) async {
    try {
      final data = await _apiService.login(loginValue, password);
      final userMap = data['user'];
      _userId =
          userMap['user_id'] is int
              ? userMap['user_id']
              : int.tryParse(userMap['user_id']?.toString() ?? '');
      _token = userMap['token']?.toString();
      debugPrint('[RegistrationProvider] Login successful for user $_userId');
      notifyListeners();
    } catch (e) {
      debugPrint('[RegistrationProvider] Login failed: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<void> loadDashboard({String? period, int? categoryId}) async {
    if (_userId == null) {
      dashboardError = 'No user logged in';
      debugPrint(
        '[RegistrationProvider] Dashboard load error: No user logged in',
      );
      notifyListeners();
      return;
    }
    dashboardLoading = true;
    dashboardError = null;
    notifyListeners();

    try {
      final data = await _apiService.fetchDashboard(
        userId: _userId!,
        period: period,
        categoryId: categoryId,
      );
      dashboardMetrics = data['metrics'];
      dashboardBusinessProfile = data['business_profile'];
      dashboardSalesTrend = data['sales_trend'];
      dashboardError = null;
      debugPrint('[RegistrationProvider] Dashboard loaded.');
    } catch (e) {
      dashboardError = e.toString();
      debugPrint('[RegistrationProvider] Dashboard load failed: $e');
    }
    dashboardLoading = false;
    notifyListeners();
  }
}
