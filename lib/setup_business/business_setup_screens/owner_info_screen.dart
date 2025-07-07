import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart';

final List<Map<String, dynamic>> regions = [
  {'id': 1, 'name': 'Greater Accra'},
  {'id': 2, 'name': 'Ashanti'},
  {'id': 3, 'name': 'Volta'},
  {'id': 4, 'name': 'Eastern'},
  {'id': 5, 'name': 'Northern'},
];
final List<Map<String, dynamic>> districts = [
  {'id': 1, 'name': 'Accra'},
  {'id': 2, 'name': 'Kumasi'},
  {'id': 3, 'name': 'Ho'},
];
final List<Map<String, dynamic>> towns = [
  {'id': 1, 'name': 'Osu'},
  {'id': 2, 'name': 'Madina'},
  {'id': 3, 'name': 'East Legon'},
];

class OwnerInfoScreen extends StatefulWidget {
  const OwnerInfoScreen({super.key});

  @override
  State<OwnerInfoScreen> createState() => _OwnerInfoScreenState();
}

class _OwnerInfoScreenState extends State<OwnerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _gender = 'male';
  String _ageGroup = '25_34';
  String _selectedIdType = 'ghana_card';
  File? _idImage;
  int _regionId = 1;
  int _districtId = 1;
  int _townId = 1;
  bool _isLoading = false;

  final List<String> _ageGroups = [
    'under_25',
    '25_34',
    '35_44',
    '45_54',
    '55_plus',
  ];
  final List<String> _idTypes = ['ghana_card', 'voter_id', 'passport', 'none'];

  Future<void> _pickIdImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (pickedFile != null) setState(() => _idImage = File(pickedFile.path));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onNext() async {
    if (!_formKey.currentState!.validate()) return;
    // NOTE: ID image is only stored locally for possible future use, not sent to backend
    if (_selectedIdType != 'none' && _idImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please upload ID image')));
      return;
    }

    setState(() => _isLoading = true);
    final provider = Provider.of<RegistrationProvider>(context, listen: false);

    try {
      final fullName = _nameController.text.trim().split(' ');
      final firstName = fullName.isNotEmpty ? fullName.first : '';
      final lastName = fullName.length > 1 ? fullName.sublist(1).join(' ') : '';

      await provider.registerUserAndCustomer(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: firstName,
        lastName: lastName,
        userType: 'customer',
        mobileNumber: _mobileController.text.trim(),
        gender: _gender,
        ageGroup: _ageGroup,
        nationalIdType: _selectedIdType,
        // Image is not sent to backend, just saved in model for potential local use
        nationalIdImage: null,
        regionId: _regionId,
        districtId: _districtId,
        townId: _townId,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamed(context, '/business-info');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to proceed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Owner Info'),
        backgroundColor: const Color(0xFF1BAEA6),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator:
                    (val) =>
                        val == null ||
                                !RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(val)
                            ? 'Enter valid email'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (val) =>
                        val == null || val.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number (+233...)',
                ),
                keyboardType: TextInputType.phone,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children:
                    ['male', 'female'].map((g) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(g[0].toUpperCase() + g.substring(1)),
                          value: g,
                          groupValue: _gender,
                          onChanged: (val) => setState(() => _gender = val!),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _ageGroup,
                items:
                    _ageGroups
                        .map(
                          (age) => DropdownMenuItem(
                            value: age,
                            child: Text(age.replaceAll('_', '-')),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _ageGroup = val!),
                decoration: const InputDecoration(labelText: 'Age Group'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIdType,
                items:
                    _idTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.replaceAll('_', ' ').toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _selectedIdType = val!),
                decoration: const InputDecoration(
                  labelText: 'National ID Type',
                ),
              ),
              if (_selectedIdType != 'none') ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickIdImage,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child:
                        _idImage == null
                            ? const Center(
                              child: Text('Tap to upload ID picture'),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _idImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _regionId,
                items:
                    regions
                        .map(
                          (region) => DropdownMenuItem<int>(
                            value: region['id'],
                            child: Text(region['name']),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _regionId = val!),
                decoration: const InputDecoration(labelText: 'Region'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _districtId,
                items:
                    districts
                        .map(
                          (district) => DropdownMenuItem<int>(
                            value: district['id'],
                            child: Text(district['name']),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _districtId = val!),
                decoration: const InputDecoration(labelText: 'District'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _townId,
                items:
                    towns
                        .map(
                          (town) => DropdownMenuItem<int>(
                            value: town['id'],
                            child: Text(town['name']),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _townId = val!),
                decoration: const InputDecoration(labelText: 'Town/Community'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onNext,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
