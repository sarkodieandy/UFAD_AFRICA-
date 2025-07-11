import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/registration_provider.dart';

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
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to Terms and Policy')),
      );
      return;
    }

    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final reg = provider.registration;
    if (reg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing registration data.')),
      );
      if (kDebugMode) print('ConsentScreen: Registration data is null!');
      return;
    }

    setState(() => _loading = true);

    if (kDebugMode) {
      print('ConsentScreen: About to submit registration data:');
      print(reg.copyWith(
        termsAgreed: 'yes',
        receiveUpdates: agreeToUpdates ? 'yes' : 'no',
      ).toJson());
    }

    try {
      provider.setRegistration(
        reg.copyWith(
          termsAgreed: 'yes',
          receiveUpdates: agreeToUpdates ? 'yes' : 'no',
        ),
      );
      await provider.submitRegistration();

      if (kDebugMode) {
        print('ConsentScreen: Registration successful, navigating to success');
      }

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/registration-success',
          (_) => false,
        );
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('====================================');
        print('ConsentScreen: Registration failed!');
        print('Error: $e');
        print('Stack trace:\n$stack');
        print('Registration data:');
        print(reg.copyWith(
          termsAgreed: 'yes',
          receiveUpdates: agreeToUpdates ? 'yes' : 'no',
        ).toJson());
        print('====================================');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit registration: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consent'),
        backgroundColor: const Color(0xFF1BAEA6),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          CheckboxListTile(
            value: agreeToTerms,
            activeColor: const Color(0xFF1BAEA6),
            onChanged: _loading
                ? null
                : (val) => setState(() => agreeToTerms = val ?? false),
            title: const Text(
              'I agree to UFAD’s Terms and Data Use Policy',
            ),
          ),
          CheckboxListTile(
            value: agreeToUpdates,
            activeColor: const Color(0xFF1BAEA6),
            onChanged: _loading
                ? null
                : (val) => setState(() => agreeToUpdates = val ?? false),
            title: const Text(
              'I agree to receive updates and support from UFAD',
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _submitRegistration,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1BAEA6),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text('Submit Registration'),
            ),
          ),
        ],
      ),
    );
  }
}
