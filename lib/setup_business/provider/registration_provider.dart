import 'package:flutter/material.dart';
import 'package:ufad/setup_business/models/business_registration.dart';
import 'package:ufad/setup_business/services/register_api.dart';

class RegistrationProvider with ChangeNotifier {
  BusinessRegistration? _registration;
  int? _userId;
  String? _token;

  BusinessRegistration? get registration => _registration;
  int? get userId => _userId;
  String? get token => _token;

  final ApiService _apiService = ApiService();

  /// Update registration data for any step.
  void setRegistration(BusinessRegistration registration) {
    _registration = registration;
    notifyListeners();
  }

  /// Step 1: Owner info (from OwnerInfoScreen)
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
    required int townId, required nationalIdImage,
    // National ID image is not required for JSON API version, remove from args
  }) async {
    // Create or update the registration draft.
    _registration = BusinessRegistration(
      staffId: 0,
      fullName: '$firstName $lastName',
      mobileNumber: mobileNumber,
      gender: gender,
      ageGroup: ageGroup,
      nationalIdType: nationalIdType,
      nationalIdImage: null, // Not uploaded (only local use)
      regionId: regionId,
      districtId: districtId,
      townId: townId,
      businessName: '',
      businessType: '',
      businessRegistered: '',
      registrationDocument: null,
      businessSector: '',
      mainProductService: '',
      businessStartYear: DateTime.now().year,
      businessLocation: '',
      gpsAddress: null,
      businessPhone: '',
      estimatedWeeklySales: '',
      numberOfWorkers: '',
      recordKeepingMethod: '',
      mobileMoneyNumber: null,
      hasInsurance: '',
      pensionScheme: '',
      bankLoan: '',
      termsAgreed: '',
      receiveUpdates: '',
      supportNeeds: [],
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      userType: userType,
    );
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// Step 2+: Business info and additional data can be updated with setRegistration()

  /// Final submission to API
  Future<void> submitRegistration() async {
    final r = _registration;
    if (r == null) throw Exception('Registration data not set.');

    // Construct username fallback logic
    final String username =
        (r.username != null && r.username!.isNotEmpty)
            ? r.username!
            : ((r.email != null && r.email!.contains('@'))
                ? r.email!.split('@')[0]
                : ((r.firstName ?? 'user') + (r.lastName ?? '')));

    // Debug: print the outgoing data
    debugPrint('ConsentScreen: About to submit registration data:');
    debugPrint(r.toJson().toString());

    try {
      final result = await _apiService.registerUser(
        username: username,
        email: r.email ?? '',
        password: r.password ?? '',
        firstName: r.firstName ?? '',
        lastName: r.lastName ?? '',
        userType: r.userType ?? '',
        mobileNumber: r.mobileNumber,
        gender: r.gender,
        ageGroup: r.ageGroup,
        nationalIdType: r.nationalIdType,
        regionId: r.regionId,
        districtId: r.districtId,
        townId: r.townId,
        businessName: r.businessName,
        businessType: r.businessType,
        businessRegistered: r.businessRegistered,
        businessSector: r.businessSector,
        mainProductService: r.mainProductService,
        businessStartYear: r.businessStartYear,
        businessLocation: r.businessLocation,
        businessPhone: r.businessPhone,
        estimatedWeeklySales: r.estimatedWeeklySales,
        numberOfWorkers: r.numberOfWorkers,
        recordKeepingMethod: r.recordKeepingMethod,
        hasInsurance: r.hasInsurance,
        pensionScheme: r.pensionScheme,
        bankLoan: r.bankLoan,
        termsAgreed: r.termsAgreed,
        receiveUpdates: r.receiveUpdates,
        supportNeeds: r.supportNeeds, // List<int>
      );
      // Handle returned data
      final userIdVal = result['user_id'];
      _userId =
          userIdVal is int
              ? userIdVal
              : int.tryParse(userIdVal?.toString() ?? '');
      _token = result['token']?.toString();
      notifyListeners();
    } catch (e, st) {
      debugPrint('ConsentScreen: Registration failed!');
      debugPrint('ConsentScreen: Exception: $e');
      debugPrint('ConsentScreen: Stack trace: $st');
      throw Exception('Registration failed: $e');
    }
  }

  /// Login method for completeness
  Future<void> login(String loginValue, String password) async {
    try {
      final data = await _apiService.login(loginValue, password);
      final userMap = data['user'];
      final userIdVal = userMap['user_id'];
      _userId =
          userIdVal is int
              ? userIdVal
              : int.tryParse(userIdVal?.toString() ?? '');
      _token = userMap['token']?.toString();
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
