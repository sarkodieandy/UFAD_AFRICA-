import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://ufad.ufadafrica.com/api/index.php';
  static const String authHeader = 'Basic YWRtaW46MTIzNDU2Nzg=';

  // -------------------- AUTH --------------------
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required int regionId,
    required int districtId,
    required int townId,
    String? profileImageBase64,
    required String fullName,
    required String gender,
    required String ageGroup,
    required String nationalIdType,
    required String businessName,
    required String businessType,
    required String businessRegistered,
    required String businessSector,
    required String mainProductService,
    required int businessStartYear,
    required String businessLocation,
    String? gpsAddress,
    required String businessPhone,
    required String estimatedWeeklySales,
    required String numberOfWorkers,
    required String recordKeepingMethod,
    String? mobileMoneyNumber,
    required String hasInsurance,
    required String pensionScheme,
    required String bankLoan,
    required String termsAgreed,
    required String receiveUpdates,
    List<int>? supportNeeds,
  }) async {
    final Map<String, dynamic> fields = {
      'username': username,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'region_id': regionId,
      'district_id': districtId,
      'town_id': townId,
      if (profileImageBase64 != null && profileImageBase64.isNotEmpty)
        'profile_image': profileImageBase64,
      'full_name': fullName,
      'gender': gender,
      'age_group': ageGroup,
      'national_id_type': nationalIdType,
      'business_name': businessName,
      'business_type': businessType,
      'business_registered': businessRegistered,
      'business_sector': businessSector,
      'main_product_service': mainProductService,
      'business_start_year': businessStartYear,
      'business_location': businessLocation,
      if (gpsAddress != null && gpsAddress.isNotEmpty)
        'gps_address': gpsAddress,
      'business_phone': businessPhone,
      'estimated_weekly_sales': estimatedWeeklySales,
      'number_of_workers': numberOfWorkers,
      'record_keeping_method': recordKeepingMethod,
      if (mobileMoneyNumber != null && mobileMoneyNumber.isNotEmpty)
        'mobile_money_number': mobileMoneyNumber,
      'has_insurance': hasInsurance,
      'pension_scheme': pensionScheme,
      'bank_loan': bankLoan,
      'terms_agreed': termsAgreed,
      'receive_updates': receiveUpdates,
      if (supportNeeds != null && supportNeeds.isNotEmpty)
        'support_needs': supportNeeds,
    };

    if (kDebugMode) print('[API] Register JSON fields: $fields');

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Register response: ${response.statusCode} - ${response.body}',
        );
      }

      final json = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (json['status'] == 201 || json['status'] == 200) {
          return json['data'];
        }
        throw Exception(json['message'] ?? 'Unknown error');
      }
      throw Exception(json['message'] ?? 'Registration failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] RegisterUser Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] RegisterUser Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Registration API error: $e');
    }
  }

  Future<Map<String, dynamic>> login(String login, String password) async {
    final url = '$baseUrl/login?login=$login&password=$password';
    http.Response? response;
    try {
      response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': authHeader},
      );
      final json = jsonDecode(response.body);

      if (kDebugMode) {
        print(
          '[API] Login response: ${response.statusCode} - ${response.body}',
        );
      }

      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Login failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] Login Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] Login Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Login API error: $e');
    }
  }

  // -------------------- DASHBOARD --------------------
  Future<Map<String, dynamic>> fetchDashboard({
    required int userId,
    String? period,
    int? categoryId,
  }) async {
    final params = {
      'user_id': userId.toString(),
      if (period != null) 'period': period,
      if (categoryId != null) 'category_id': categoryId.toString(),
    };
    final uri = Uri.parse(
      '$baseUrl/dashboard',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Dashboard response: ${response.statusCode} - ${response.body}',
        );
      }

      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Dashboard fetch failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchDashboard Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchDashboard Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Dashboard API error: $e');
    }
  }

  // -------------------- CUSTOMERS --------------------
  Future<List<dynamic>> fetchCustomers({
    required int userId,
    int? categoryId,
    String? accountType,
  }) async {
    final params = {
      'user_id': userId.toString(),
      if (categoryId != null) 'category_id': categoryId.toString(),
      if (accountType != null) 'account_type': accountType,
    };
    final uri = Uri.parse(
      '$baseUrl/customers',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch customers response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Fetch customers failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchCustomers Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchCustomers Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch customers API error: $e');
    }
  }

  Future<Map<String, dynamic>> addCustomer({
    required int userId,
    required String name,
    required String accountType,
    required String businessName,
    required int categoryId,
    required String phone,
    required String mobile,
    required String location,
  }) async {
    final fields = {
      'user_id': userId,
      'name': name,
      'account_type': accountType,
      'business_name': businessName,
      'category_id': categoryId,
      'phone': phone,
      'mobile': mobile,
      'location': location,
    };

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/customers'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Add customer response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 && json['status'] == 201) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Add customer failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] addCustomer Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] addCustomer Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Add customer API error: $e');
    }
  }

  Future<void> updateCustomer({
    required int customerId,
    required int userId,
    required String name,
    required String accountType,
    required String businessName,
    required int categoryId,
    required String phone,
    required String mobile,
    required String location,
  }) async {
    final fields = {
      'user_id': userId,
      'name': name,
      'account_type': accountType,
      'business_name': businessName,
      'category_id': categoryId,
      'phone': phone,
      'mobile': mobile,
      'location': location,
    };

    http.Response? response;
    try {
      response = await http.put(
        Uri.parse('$baseUrl/customers/$customerId'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Update customer response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return;
      }
      throw Exception(json['message'] ?? 'Update customer failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] updateCustomer Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] updateCustomer Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Update customer API error: $e');
    }
  }

  Future<void> deleteCustomer({
    required int customerId,
    required int userId,
  }) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse(
      '$baseUrl/customers/$customerId',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.delete(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Delete customer response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return;
      }
      throw Exception(json['message'] ?? 'Delete customer failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] deleteCustomer Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] deleteCustomer Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Delete customer API error: $e');
    }
  }

  // -------------------- LOANS --------------------
  Future<Map<String, dynamic>> fetchLoans({required int userId}) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse('$baseUrl/loans').replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch loans response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Fetch loans failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchLoans Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchLoans Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch loans API error: $e');
    }
  }

  Future<Map<String, dynamic>> applyLoan({
    required int userId,
    required String product,
    required double amount,
    required String tenure,
  }) async {
    final fields = {
      'user_id': userId,
      'product': product,
      'amount': amount,
      'tenure': tenure,
    };

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/loans'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Apply loan response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 && json['status'] == 201) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Apply loan failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] applyLoan Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] applyLoan Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Apply loan API error: $e');
    }
  }

  Future<Map<String, dynamic>> fetchLoanRepayments({
    required int userId,
  }) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse(
      '$baseUrl/loan-repayments',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch loan repayments response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Fetch loan repayments failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchLoanRepayments Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchLoanRepayments Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch loan repayments API error: $e');
    }
  }

  // ====================== POS METHODS ========================
  Future<Map<String, dynamic>> fetchPOSSummary({required int userId}) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse(
      '$baseUrl/pos/summary',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch POS summary response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as Map<String, dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch POS summary failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchPOSSummary Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchPOSSummary Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch POS summary API error: $e');
    }
  }

  Future<List<dynamic>> fetchPOSSales({
    required int userId,
    String? startDate,
    String? endDate,
    String? debtor,
    bool onlyDebtors = false,
  }) async {
    final params = {
      'user_id': userId.toString(),
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (debtor != null) 'debtor': debtor,
      'only_debtors': onlyDebtors.toString(),
    };
    final uri = Uri.parse(
      '$baseUrl/pos/sales',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch POS sales response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch POS sales failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchPOSSales Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchPOSSales Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch POS sales API error: $e');
    }
  }

  Future<List<dynamic>> fetchProducts({required int userId}) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse('$baseUrl/products').replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch products response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch products failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchProducts Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchProducts Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch products API error: $e');
    }
  }

  // CREATE SALE
  Future<Map<String, dynamic>> createSale({
    required int userId,
    int? customerId,
    required List<Map<String, dynamic>> items,
    required double paymentAmount,
    required String paymentAccount,
    String? dueDate,
  }) async {
    final fields = {
      'user_id': userId,
      if (customerId != null) 'customer_id': customerId,
      'items': items,
      'payment_amount': paymentAmount,
      'payment_account': paymentAccount,
      if (dueDate != null) 'due_date': dueDate,
    };

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/pos/sales'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Create sale response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 && json['status'] == 201) {
        return json['data'] as Map<String, dynamic>;
      }
      throw Exception(json['message'] ?? 'Create sale failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] createSale Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] createSale Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Create sale API error: $e');
    }
  }

  // PAY DEBT
  Future<void> payDebt({
    required int saleId,
    required double amount,
    required String paymentMethod,
  }) async {
    final fields = {
      'sale_id': saleId,
      'amount': amount,
      'payment_method': paymentMethod,
    };

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/pos/payments'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Pay debt response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 && json['status'] == 201) {
        return;
      }
      throw Exception(json['message'] ?? 'Pay debt failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] payDebt Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] payDebt Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Pay debt API error: $e');
    }
  }

  // BUY CREDITS
  Future<void> buyCredits({required int userId, required double amount}) async {
    final fields = {'user_id': userId, 'amount': amount};

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/pos/credits'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Buy credits response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 && json['status'] == 201) {
        return;
      }
      throw Exception(json['message'] ?? 'Buy credits failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] buyCredits Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] buyCredits Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Buy credits API error: $e');
    }
  }

  // ----------- NEW: SALE ITEMS, PAYMENTS, CUSTOMER PURCHASES ------------
  Future<List<dynamic>> fetchSaleItems({
    required int saleId,
    required int userId,
  }) async {
    final params = {'user_id': userId.toString(), 'sale_id': saleId.toString()};
    final uri = Uri.parse(
      '$baseUrl/pos/sale-items',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch sale items response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch sale items failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchSaleItems Error: $e');
      }
      if (response != null)
        // ignore: curly_braces_in_flow_control_structures
        if (kDebugMode) {
          print(
          '[API] fetchSaleItems Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      throw Exception('Fetch sale items API error: $e');
    }
  }

  Future<List<dynamic>> fetchSalePayments({
    required int saleId,
    required int userId,
  }) async {
    final params = {'user_id': userId.toString(), 'sale_id': saleId.toString()};
    final uri = Uri.parse(
      '$baseUrl/pos/sale-payments',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch sale payments response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch sale payments failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchSalePayments Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchSalePayments Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch sale payments API error: $e');
    }
  }

  Future<List<dynamic>> fetchCustomerPurchases({
    required int customerId,
    required int userId,
  }) async {
    final params = {
      'user_id': userId.toString(),
      'customer_id': customerId.toString(),
    };
    final uri = Uri.parse(
      '$baseUrl/pos/customer-purchases',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch customer purchases response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch customer purchases failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchCustomerPurchases Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchCustomerPurchases Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch customer purchases API error: $e');
    }
  }

  // ========== PRODUCTS ==========
  Future<List<dynamic>> fetchProductList({required int userId}) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse('$baseUrl/products').replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch products response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch products failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchProductList Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchProductList Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch products API error: $e');
    }
  }

  Future<List<dynamic>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/product-categories');

    http.Response? response;
    try {
      response = await http.get(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Fetch categories response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return json['data'] as List<dynamic>;
      }
      throw Exception(json['message'] ?? 'Fetch categories failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] fetchCategories Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] fetchCategories Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Fetch categories API error: $e');
    }
  }

  Future<Map<String, dynamic>> addProduct({
    required int userId,
    required String name,
    required int categoryId,
    required double price,
    required String description,
  }) async {
    final fields = {
      'user_id': userId,
      'name': name,
      'category_id': categoryId,
      'price': price,
      'description': description,
    };

    http.Response? response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Add product response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 201 && json['status'] == 201) {
        return json['data'];
      }
      throw Exception(json['message'] ?? 'Add product failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] addProduct Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] addProduct Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Add product API error: $e');
    }
  }

  Future<void> updateProduct({
    required int productId,
    required int userId,
    required String name,
    required int categoryId,
    required double price,
    required String description,
  }) async {
    final fields = {
      'user_id': userId,
      'name': name,
      'category_id': categoryId,
      'price': price,
      'description': description,
    };

    http.Response? response;
    try {
      response = await http.put(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {
          'Authorization': authHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fields),
      );
      if (kDebugMode) {
        print(
          '[API] Update product response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return;
      }
      throw Exception(json['message'] ?? 'Update product failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] updateProduct Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] updateProduct Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Update product API error: $e');
    }
  }

  Future<void> deleteProduct({
    required int productId,
    required int userId,
  }) async {
    final params = {'user_id': userId.toString()};
    final uri = Uri.parse(
      '$baseUrl/products/$productId',
    ).replace(queryParameters: params);

    http.Response? response;
    try {
      response = await http.delete(uri, headers: {'Authorization': authHeader});
      if (kDebugMode) {
        print(
          '[API] Delete product response: ${response.statusCode} - ${response.body}',
        );
      }
      final json = jsonDecode(response.body);
      if (response.statusCode == 200 && json['status'] == 200) {
        return;
      }
      throw Exception(json['message'] ?? 'Delete product failed');
    } catch (e) {
      if (kDebugMode) {
        print('[API] deleteProduct Error: $e');
      }
      if (response != null) {
        if (kDebugMode) {
          print(
          '[API] deleteProduct Failed Response: ${response.statusCode} - ${response.body}',
        );
        }
      }
      throw Exception('Delete product API error: $e');
    }
  }
}
