import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/SuppliersProvider.dart';
import '../models/supplier_model.dart';

import '../core/constants/colors.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String contactPerson = '';
  String phone = '';
  String address = '';
  String email = '';
  bool loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => loading = true);

    final newSupplier = Supplier(
      id: 0, // Will be ignored by backend
      name: name,
      contactPerson: contactPerson,
      phone: phone,
      address: address,
      email: email,
    );

    try {
      await Provider.of<SupplierProvider>(
        context,
        listen: false,
      ).addSupplier(newSupplier);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Supplier added successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Supplier'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(
                label: 'Supplier Name',
                onSaved: (val) => name = val!,
              ),
              _buildField(
                label: 'Contact Person',
                onSaved: (val) => contactPerson = val!,
              ),
              _buildField(
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                onSaved: (val) => phone = val!,
              ),
              _buildField(label: 'Address', onSaved: (val) => address = val!),
              _buildField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                onSaved: (val) => email = val!,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon:
                    loading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.save),
                label: const Text('Save Supplier'),
                onPressed: loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    TextInputType? keyboardType,
    required FormFieldSetter<String> onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator:
            (val) => val == null || val.isEmpty ? 'Please enter $label' : null,
        onSaved: onSaved,
      ),
    );
  }
}
