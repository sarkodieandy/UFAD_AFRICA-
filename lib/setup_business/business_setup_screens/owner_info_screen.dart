import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart';
import 'package:ufad/setup_business/models/business_registration_model.dart';

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

  String _gender = 'male';
  String _ageGroup = '25_34';
  String _selectedIdType = 'ghana_card';
  File? _idImage;

  int? _regionId = 1;
  int? _districtId = 1;
  int? _townId = 1;

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
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;
    final provider = Provider.of<RegistrationProvider>(context, listen: false);

    provider.setRegistration(
      BusinessRegistration(
        staffId: 1,
        fullName: _nameController.text,
        mobileNumber: _mobileController.text,
        gender: _gender,
        ageGroup: _ageGroup,
        nationalIdType: _selectedIdType,
        nationalIdImage: _idImage?.path,
        regionId: _regionId ?? 1,
        districtId: _districtId ?? 1,
        townId: _townId ?? 1,
        businessName: '',
        businessType: '',
        businessRegistered: '',
        registrationDocument: null,
        businessSector: '',
        mainProductService: '',
        businessStartYear: DateTime.now().year,
        businessLocation: '',
        gpsAddress: '',
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
      ),
    );
    Navigator.pushNamed(context, '/business-info');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Owner Info'),
        backgroundColor: const Color(0xFF007BFF),
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
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number (+233...)',
                ),
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children:
                    ['male', 'female'].map((g) {
                      return Expanded(
                        child: RadioListTile(
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
                            : Image.file(_idImage!, fit: BoxFit.cover),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              // Region Dropdown
              DropdownButtonFormField<int>(
                value: _regionId,
                items:
                    regions
                        .map(
                          (region) => DropdownMenuItem<int>(
                            value: region['id'] as int,
                            child: Text(region['name']),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _regionId = val!),
                decoration: const InputDecoration(labelText: 'Region'),
              ),
              const SizedBox(height: 16),
              // District Dropdown
              DropdownButtonFormField<int>(
                value: _districtId,
                items:
                    districts
                        .map(
                          (district) => DropdownMenuItem<int>(
                            value: district['id'] as int,
                            child: Text(district['name']),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => _districtId = val!),
                decoration: const InputDecoration(labelText: 'District'),
              ),
              const SizedBox(height: 16),
              // Town Dropdown
              DropdownButtonFormField<int>(
                value: _townId,
                items:
                    towns
                        .map(
                          (town) => DropdownMenuItem<int>(
                            value: town['id'] as int,
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
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007BFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
