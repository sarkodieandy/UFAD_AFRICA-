// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool agreeToTerms = true;
  bool agreeToUpdates = true;
  bool _loading = false;

  Future<void> _submitRegistration() async {
    print('---- SUBMIT BUTTON CLICKED ----');
    if (!agreeToTerms) {
      print('User did not agree to terms');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to Terms and Policy")),
      );
      return;
    }

    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final reg = provider.registration;
    if (reg == null) {
      print('No registration data in provider!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing registration data.")),
      );
      return;
    }

    print('--- PRINTING REGISTRATION DATA BEFORE SUBMIT ---');
    final regJson =
        reg
            .copyWith(
              termsAgreed: 'yes',
              receiveUpdates: agreeToUpdates ? 'yes' : 'no',
            )
            .toJson();

    regJson.forEach((k, v) => print('$k (${v.runtimeType}): $v'));
    print('--- END REGISTRATION DATA PRINT ---');

    provider.setRegistration(
      reg.copyWith(
        termsAgreed: 'yes',
        receiveUpdates: agreeToUpdates ? 'yes' : 'no',
      ),
    );

    setState(() => _loading = true);
    try {
      print('Calling provider.submitRegistration()...');
      await provider.submitRegistration();
      print('Submission successful, navigating to success screen!');
      setState(() => _loading = false);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/registration-success',
        (_) => false,
      );
    } catch (e, stack) {
      print('SUBMISSION ERROR: $e\n$stack');
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit registration: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consent"),
        backgroundColor: const Color(0xFF4361EE),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            children: [
              CheckboxListTile(
                value: agreeToTerms,
                activeColor: const Color(0xFF4361EE),
                onChanged: (val) => setState(() => agreeToTerms = val ?? false),
                title: const Text(
                  "I agree to UFAD’s Terms and Data Use Policy",
                ),
              ),
              CheckboxListTile(
                value: agreeToUpdates,
                activeColor: const Color(0xFF4361EE),
                onChanged:
                    (val) => setState(() => agreeToUpdates = val ?? false),
                title: const Text(
                  "I agree to receive updates and support from UFAD",
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submitRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4361EE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Submit Registration',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
