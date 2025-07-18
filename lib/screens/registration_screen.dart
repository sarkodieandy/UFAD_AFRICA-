import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  final Map<String, int> supportNeedMap = {
    'Financial Assistance': 1,
    'Training & Capacity Building': 2,
    'Marketing Support': 3,
    'Legal/Regulatory Assistance': 4,
    'Mentorship & Networking': 5,
  };

  late final List<String> _supportOptions;
  File? _imageFile;
  bool _loading = false;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _supportOptions = supportNeedMap.keys.toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final mimeType =
          picked.path.endsWith('.png') ? 'image/png' : 'image/jpeg';

      setState(() {
        _imageFile = File(picked.path);
        _formData['profile_image'] =
            'data:$mimeType;base64,${base64Encode(bytes)}';
      });
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final rawNeeds = _formData['support_needs'];
    final needsList =
        rawNeeds is List ? rawNeeds.whereType<String>().toList() : [];
    _formData['support_needs'] =
        needsList.map((e) => supportNeedMap[e]).whereType<int>().toList();

    _formData['business_phone'] = _formData['mobile_number'];
    _formData['mobile_money_number'] ??= _formData['mobile_number'];
    _formData['full_name'] =
        '${_formData['first_name']} ${_formData['last_name']}';

    final required = [
      'username',
      'email',
      'password',
      'first_name',
      'last_name',
      'mobile_number',
      'business_name',
      'main_product_service',
      'business_phone',
      'gender',
      'age_group',
    ];

    for (final key in required) {
      final value = _formData[key];
      if (value == null || (value is String && value.trim().isEmpty)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Missing: $key')));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Signup failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body:
          _loading
              ? const Loader()
              : Column(
                children: [
                  // App bar with animation
                  Container(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slide(),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.green.withOpacity(0.05),
                            AppColors.white,
                          ],
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Profile picture with animation
                              Center(
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Animate(
                                    effects: [
                                      FadeEffect(duration: 500.ms),
                                      ScaleEffect(
                                        begin: const Offset(0.9, 0.9),
                                      ),
                                    ],
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.green.withOpacity(
                                              0.1,
                                            ),
                                            border: Border.all(
                                              color: AppColors.green,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 10,
                                              ),
                                            ],
                                            image:
                                                _imageFile != null
                                                    ? DecorationImage(
                                                      image: FileImage(
                                                        _imageFile!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                    : null,
                                          ),
                                          child:
                                              _imageFile == null
                                                  ? Icon(
                                                    Icons.add_a_photo,
                                                    size: 30,
                                                    color: AppColors.green,
                                                  )
                                                  : null,
                                        ),
                                        if (_imageFile != null)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: AppColors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Form sections with page view
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: PageView(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    // Page 1: Account and Personal Info
                                    _buildAccountPersonalInfo(),

                                    // Page 2: Business Info
                                    _buildBusinessInfo(),

                                    // Page 3: Additional Info
                                    _buildAdditionalInfo(),
                                  ],
                                ),
                              ),

                              // Navigation buttons
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Back button
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_pageController.page! > 0) {
                                          _pageController.previousPage(
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[200],
                                        foregroundColor: Colors.grey[800],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text('Back'),
                                    ).animate().fadeIn(),

                                    // Next/Submit button
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_pageController.page! < 2) {
                                          _pageController.nextPage(
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          );
                                        } else {
                                          _submit();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.green,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        elevation: 3,
                                      ),
                                      child: Text(
                                        _pageController.hasClients &&
                                                _pageController.page! < 2
                                            ? 'Next'
                                            : 'Submit',
                                      ),
                                    ).animate().fadeIn(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildAccountPersonalInfo() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader('Account Information'),
          _buildModernTextField('Username', 'username', Icons.person),
          _buildModernTextField(
            'Email',
            'email',
            Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildModernTextField(
            'Password',
            'password',
            Icons.lock,
            obscureText: true,
            minLen: 6,
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Personal Details'),
          _buildModernTextField('First Name', 'first_name', Icons.badge),
          _buildModernTextField('Last Name', 'last_name', Icons.badge),
          _buildModernTextField('Mobile Number', 'mobile_number', Icons.phone),
          _buildModernTextField(
            'Mobile Money Number',
            'mobile_money_number',
            Icons.phone_android,
          ),
          _buildModernDropdown('Gender', 'gender', Icons.transgender, {
            'male': 'Male',
            'female': 'Female',
          }),
          _buildModernDropdown('Age Group', 'age_group', Icons.cake, {
            'under_25': 'Under 25',
            '25_34': '25 - 34',
            '35_44': '35 - 44',
            '45_54': '45 - 54',
            '55_plus': '55+',
          }),
        ],
      ),
    );
  }

  Widget _buildBusinessInfo() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSectionHeader('Business Information'),
          _buildModernTextField(
            'Business Name',
            'business_name',
            Icons.business,
          ),
          _buildModernTextField(
            'Main Product/Service',
            'main_product_service',
            Icons.shopping_bag,
          ),
          _buildModernTextField(
            'Business Location',
            'business_location',
            Icons.location_on,
          ),
          _buildModernTextField(
            'Start Year',
            'business_start_year',
            Icons.calendar_today,
            keyboardType: TextInputType.number,
          ),
          _buildModernDropdown(
            'Business Registered',
            'business_registered',
            Icons.assignment_turned_in,
            {'yes': 'Yes', 'no': 'No'},
          ),
          _buildModernDropdown(
            'Business Type',
            'business_type',
            Icons.category,
            {
              'informal': 'Informal',
              'sole_proprietor': 'Sole Proprietor',
              'partnership': 'Partnership',
              'other': 'Other',
            },
          ),
          _buildModernDropdown('Sector', 'business_sector', Icons.store, {
            'retail': 'Retail',
            'wholesale': 'Wholesale',
            'service': 'Service',
            'manufacturing': 'Manufacturing',
          }),
          _buildModernDropdown(
            'Weekly Sales',
            'estimated_weekly_sales',
            Icons.attach_money,
            {
              'less_500': '< GHS 500',
              '500_1000': 'GHS 500 - 1000',
              '1000_5000': 'GHS 1000 - 5000',
              'over_5000': '> GHS 5000',
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildModernDropdown('Workers', 'number_of_workers', Icons.people, {
            '1': '1',
            '2': '2',
            '3_5': '3 - 5',
            '6_10': '6 - 10',
            'over_10': '10+',
          }),
          _buildModernDropdown(
            'Record Keeping',
            'record_keeping_method',
            Icons.book,
            {
              'none': 'None',
              'paper_notebook': 'Paper Notebook',
              'phone_app': 'Phone App',
              'excel_computer': 'Excel / Computer',
            },
          ),
          _buildModernDropdown('Insurance', 'has_insurance', Icons.security, {
            'yes': 'Yes',
            'no': 'No',
          }),
          _buildModernDropdown(
            'Pension Scheme',
            'pension_scheme',
            Icons.account_balance,
            {'yes': 'Yes', 'no': 'No'},
          ),
          _buildModernDropdown('Bank Loan', 'bank_loan', Icons.money, {
            'yes': 'Yes',
            'no': 'No',
          }),
          _buildModernDropdown(
            'National ID Type',
            'national_id_type',
            Icons.credit_card,
            {
              'ghana_card': 'Ghana Card',
              'passport': 'Passport',
              'voter_id': 'Voter ID',
              'none': 'None',
            },
          ),
          _buildSectionHeader('Support Needs (optional)'),
          ..._supportOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: CheckboxListTile(
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
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Consent'),
          const Text(
            'By signing up, you agree to receive communications.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTextField(
    String label,
    String key,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int minLen = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.green),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.green, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator:
            (v) => v == null || v.trim().length < minLen ? 'Required' : null,
        onSaved: (v) => _formData[key] = v?.trim(),
      ).animate().fadeIn().slide(begin: const Offset(0.1, 0)),
    );
  }

  Widget _buildModernDropdown(
    String label,
    String key,
    IconData icon,
    Map<String, String> options,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.green),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.green, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        items:
            options.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
        validator: (v) => v == null ? 'Required' : null,
        onChanged: (val) => _formData[key] = val,
      ).animate().fadeIn().slide(begin: const Offset(0.1, 0)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ).animate().fadeIn().slide(begin: const Offset(0.1, 0)),
    );
  }
}
