import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ufad/provider/registration_provider.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({super.key});

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final productController = TextEditingController();
  final locationController = TextEditingController();
  final gpsController = TextEditingController();
  final phoneController = TextEditingController();

  String? businessType;
  String? registrationStatus;
  String? selectedSector;
  int? selectedYear;
  File? registrationFile;

  final businessTypes = ['informal', 'sole_proprietor', 'partnership', 'other'];
  final sectors = [
    'retail',
    'agriculture',
    'food',
    'transport',
    'services',
    'other',
  ];
  final years = [for (int i = DateTime.now().year; i >= 2000; i--) i];

  @override
  void initState() {
    super.initState();
    // If editing, load existing values from provider
    final reg = Provider.of<RegistrationProvider>(context, listen: false).registration;
    if (reg != null) {
      nameController.text = reg.businessName;
      productController.text = reg.mainProductService;
      locationController.text = reg.businessLocation;
      gpsController.text = reg.gpsAddress ?? '';
      phoneController.text = reg.businessPhone;
      businessType = reg.businessType.isNotEmpty ? reg.businessType : null;
      registrationStatus = reg.businessRegistered.isNotEmpty ? reg.businessRegistered : null;
      selectedSector = reg.businessSector.isNotEmpty ? reg.businessSector : null;
      selectedYear = reg.businessStartYear != 0 ? reg.businessStartYear : null;
      registrationFile = reg.registrationDocument != null && reg.registrationDocument!.isNotEmpty
          ? File(reg.registrationDocument!)
          : null;
    }
  }

  Future<void> _pickRegistrationFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => registrationFile = File(picked.path));
  }

  void _onNext() {
    if (!_formKey.currentState!.validate() ||
        businessType == null ||
        registrationStatus == null ||
        selectedSector == null ||
        selectedYear == null ||
        (registrationStatus == 'yes' && registrationFile == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            registrationStatus == 'yes' && registrationFile == null
                ? 'Please attach a registration document.'
                : 'Please fill all required fields',
          ),
        ),
      );
      return;
    }

    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final reg = provider.registration;
    if (reg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing owner data')),
      );
      return;
    }

    provider.setRegistration(
      reg.copyWith(
        businessName: nameController.text,
        businessType: businessType!,
        businessRegistered: registrationStatus!.toLowerCase(),
        registrationDocument: registrationFile?.path,
        businessSector: selectedSector!,
        mainProductService: productController.text,
        businessStartYear: selectedYear!,
        businessLocation: locationController.text,
        gpsAddress: gpsController.text.isEmpty ? null : gpsController.text,
        businessPhone: phoneController.text,
      ),
    );

    Navigator.pushNamed(context, '/business-activity');
  }

  @override
  void dispose() {
    nameController.dispose();
    productController.dispose();
    locationController.dispose();
    gpsController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Info'),
        backgroundColor: const Color(0xFF1BAEA6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Business Name'),
              const SizedBox(height: 6),
              TextFormField(
                controller: nameController,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(
                  hintText: 'Enter your business name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Type of Business'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: businessType,
                decoration: const InputDecoration(hintText: 'Select type'),
                items: businessTypes
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.replaceAll('_', ' ').toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => businessType = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Business Registration'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Yes'),
                      value: 'yes',
                      groupValue: registrationStatus,
                      onChanged: (val) => setState(() => registrationStatus = val),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('No'),
                      value: 'no',
                      groupValue: registrationStatus,
                      onChanged: (val) => setState(() {
                        registrationStatus = val;
                        if (registrationStatus != 'yes') registrationFile = null;
                      }),
                    ),
                  ),
                ],
              ),
              if (registrationStatus == 'yes') ...[
                ElevatedButton.icon(
                  onPressed: _pickRegistrationFile,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Attach Registration Document'),
                ),
                if (registrationFile != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'File selected: ${registrationFile!.path.split('/').last}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              const Text('Business Sector'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedSector,
                decoration: const InputDecoration(hintText: 'Select sector'),
                items: sectors
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedSector = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Main Product or Service Offered'),
              const SizedBox(height: 6),
              TextFormField(
                controller: productController,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(
                  hintText: 'Enter product/service',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Business Start Year'),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                value: selectedYear,
                decoration: const InputDecoration(hintText: 'Select year'),
                items: years
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => selectedYear = val),
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              const Text('Business Location (Town / Area)'),
              const SizedBox(height: 6),
              TextFormField(
                controller: locationController,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(hintText: 'Enter location'),
              ),
              const SizedBox(height: 16),
              const Text('GPS Address'),
              const SizedBox(height: 6),
              TextFormField(
                controller: gpsController,
                decoration: const InputDecoration(
                  hintText: 'Enter GPS address',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Business Phone'),
              const SizedBox(height: 6),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter phone' : null,
                decoration: const InputDecoration(
                  hintText: 'Enter phone number',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1BAEA6),
                  ),
                  child: const Text('Next'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
