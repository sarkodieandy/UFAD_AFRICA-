import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/widgets/loader.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, int> supportNeedMap = {
    'Financial Assistance': 1,
    'Training & Capacity Building': 2,
    'Marketing Support': 3,
    'Legal/Regulatory Assistance': 4,
    'Mentorship & Networking': 5,
  };

  final Map<String, dynamic> _formData = {
    'support_needs': [],
    'terms_agreed': 'yes',
    'receive_updates': 'yes',
    'user_type': 'customer',
    'region_id': 1,
    'district_id': 1,
    'town_id': 1,
    'business_type': 'sole_proprietor',
    'business_registered': 'yes',
    'business_sector': 'retail',
    'business_start_year': 2020,
    'business_location': 'Accra',
    'estimated_weekly_sales': '500_1000',
    'number_of_workers': '2',
    'record_keeping_method': 'paper_notebook',
    'has_insurance': 'yes',
    'pension_scheme': 'yes',
    'bank_loan': 'yes',
    'national_id_type': 'ghana_card',
  };

  late final List<String> _supportOptions;
  File? _imageFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _supportOptions = supportNeedMap.keys.toList();
  }

 Future<void> _pickImage() async {
  final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (picked != null) {
    final bytes = await picked.readAsBytes();
    final mimeType = picked.path.endsWith('.png') ? 'image/png' : 'image/jpeg';

    setState(() {
      _imageFile = File(picked.path);
      _formData['profile_image'] = 'data:$mimeType;base64,${base64Encode(bytes)}';
    });
  }
}


  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final rawNeeds = _formData['support_needs'];
    final needsList = rawNeeds is List ? rawNeeds.whereType<String>().toList() : [];
    _formData['support_needs'] = needsList.map((e) => supportNeedMap[e]).whereType<int>().toList();

    _formData['business_phone'] = _formData['mobile_number'];
    _formData['mobile_money_number'] ??= _formData['mobile_number'];
    _formData['full_name'] = '${_formData['first_name']} ${_formData['last_name']}';

    final required = [
      'username', 'email', 'password', 'first_name', 'last_name',
      'mobile_number', 'business_name', 'main_product_service',
      'business_phone', 'gender', 'age_group'
    ];

    for (final key in required) {
      final value = _formData[key];
      if (value == null || (value is String && value.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Missing: $key')));
        return;
      }
    }

    setState(() => _loading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signup(_formData);
    setState(() => _loading = false);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Signup failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        // ignore: deprecated_member_use
                        backgroundColor: AppColors.green.withOpacity(0.1),
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.add_a_photo, size: 32, color: Colors.grey)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Account Info
                    _buildHeader('Account Information'),
                    _buildTextField('Username', 'username'),
                    _buildTextField('Email', 'email', keyboardType: TextInputType.emailAddress),
                    _buildTextField('Password', 'password', obscureText: true, minLen: 6),

                    // Personal Info
                    _buildHeader('Personal Details'),
                    _buildTextField('First Name', 'first_name'),
                    _buildTextField('Last Name', 'last_name'),
                    _buildTextField('Mobile Number', 'mobile_number'),
                    _buildTextField('Mobile Money Number', 'mobile_money_number'),
                    _buildDropdown('Gender', 'gender', {'male': 'Male', 'female': 'Female'}),
                    _buildDropdown('Age Group', 'age_group', {
                      'under_25': 'Under 25',
                      '25_34': '25 - 34',
                      '35_44': '35 - 44',
                      '45_54': '45 - 54',
                      '55_plus': '55+',
                    }),
                    _buildDropdown('National ID Type', 'national_id_type', {
                      'ghana_card': 'Ghana Card',
                      'passport': 'Passport',
                      'voter_id': 'Voter ID',
                      'none': 'None',
                    }),

                    // Business Info
                    _buildHeader('Business Information'),
                    _buildTextField('Business Name', 'business_name'),
                    _buildTextField('Main Product/Service', 'main_product_service'),
                    _buildTextField('Business Location', 'business_location'),
                    _buildTextField('Start Year', 'business_start_year',
                        keyboardType: TextInputType.number),
                    _buildDropdown('Business Registered', 'business_registered', {
                      'yes': 'Yes',
                      'no': 'No',
                    }),
                    _buildDropdown('Business Type', 'business_type', {
                      'informal': 'Informal',
                      'sole_proprietor': 'Sole Proprietor',
                      'partnership': 'Partnership',
                      'other': 'Other',
                    }),
                    _buildDropdown('Sector', 'business_sector', {
                      'retail': 'Retail',
                      'wholesale': 'Wholesale',
                      'service': 'Service',
                      'manufacturing': 'Manufacturing',
                    }),
                    _buildDropdown('Weekly Sales', 'estimated_weekly_sales', {
                      'less_500': '< GHS 500',
                      '500_1000': 'GHS 500 - 1000',
                      '1000_5000': 'GHS 1000 - 5000',
                      'over_5000': '> GHS 5000',
                    }),
                    _buildDropdown('Workers', 'number_of_workers', {
                      '1': '1',
                      '2': '2',
                      '3_5': '3 - 5',
                      '6_10': '6 - 10',
                      'over_10': '10+',
                    }),
                    _buildDropdown('Record Keeping', 'record_keeping_method', {
                      'none': 'None',
                      'paper_notebook': 'Paper Notebook',
                      'phone_app': 'Phone App',
                      'excel_computer': 'Excel / Computer',
                    }),
                    _buildDropdown('Insurance', 'has_insurance', {'yes': 'Yes', 'no': 'No'}),
                    _buildDropdown('Pension Scheme', 'pension_scheme', {'yes': 'Yes', 'no': 'No'}),
                    _buildDropdown('Bank Loan', 'bank_loan', {'yes': 'Yes', 'no': 'No'}),

                    // Support Needs
                    _buildHeader('Support Needs (optional)'),
                    ..._supportOptions.map((option) => CheckboxListTile(
                          title: Text(option),
                          value: _formData['support_needs'].contains(option),
                          onChanged: (selected) {
                            setState(() {
                              if (selected!) {
                                _formData['support_needs'].add(option);
                              } else {
                                _formData['support_needs'].remove(option);
                              }
                            });
                          },
                        )),

                    // Consent
                    _buildHeader('Consent'),
                    const Text('By signing up, you agree to receive communications.'),
                    const SizedBox(height: 20),

                    // Submit
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Create Account', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, String key,
      {TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      int minLen = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: (v) => v == null || v.trim().length < minLen ? 'Required' : null,
        onSaved: (v) => _formData[key] = v?.trim(),
      ),
    );
  }

  Widget _buildDropdown(String label, String key, Map<String, String> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField(
        decoration: InputDecoration(labelText: label),
        items: options.entries
            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        validator: (v) => v == null ? 'Required' : null,
        onChanged: (val) => _formData[key] = val,
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }
}
