import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/registration_provider.dart';

class BusinessActivityScreen extends StatefulWidget {
  const BusinessActivityScreen({super.key});

  @override
  State<BusinessActivityScreen> createState() => _BusinessActivityScreenState();
}

class _BusinessActivityScreenState extends State<BusinessActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? estimatedWeeklySales;
  String? numberOfWorkers;
  String? recordKeepingMethod;
  String? mobileMoneyNumber = '';
  String hasInsurance = 'no';
  String pensionScheme = 'no';
  String bankLoan = 'no';

  final salesOptions = {
    'less_500': 'Less than 500',
    '500_1000': '500 - 1,000',
    '1000_5000': '1,000 - 5,000',
    'over_5000': 'Over 5,000',
  };
  final workerOptions = {
    '1': '1',
    '2': '2',
    '3_5': '3 - 5',
    '6_10': '6 - 10',
    'over_10': 'More than 10',
  };
  final recordOptions = {
    'none': 'None',
    'paper_notebook': 'Paper notebook',
    'phone_app': 'Phone app',
    'excel_computer': 'Excel/computer',
  };

  @override
  void initState() {
    super.initState();
    // If user is editing, prefill with current values
    final reg = Provider.of<RegistrationProvider>(context, listen: false).registration;
    if (reg != null) {
      estimatedWeeklySales = reg.estimatedWeeklySales.isNotEmpty ? reg.estimatedWeeklySales : null;
      numberOfWorkers = reg.numberOfWorkers.isNotEmpty ? reg.numberOfWorkers : null;
      recordKeepingMethod = reg.recordKeepingMethod.isNotEmpty ? reg.recordKeepingMethod : null;
      mobileMoneyNumber = reg.mobileMoneyNumber ?? '';
      hasInsurance = reg.hasInsurance.isNotEmpty ? reg.hasInsurance : 'no';
      pensionScheme = reg.pensionScheme.isNotEmpty ? reg.pensionScheme : 'no';
      bankLoan = reg.bankLoan.isNotEmpty ? reg.bankLoan : 'no';
    }
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final regProvider = Provider.of<RegistrationProvider>(context, listen: false);
    final registration = regProvider.registration;
    if (registration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing registration base data.')),
      );
      return;
    }

    regProvider.setRegistration(
      registration.copyWith(
        estimatedWeeklySales: estimatedWeeklySales!,
        numberOfWorkers: numberOfWorkers!,
        recordKeepingMethod: recordKeepingMethod!,
        mobileMoneyNumber: (mobileMoneyNumber == null || mobileMoneyNumber!.isEmpty) ? null : mobileMoneyNumber,
        hasInsurance: hasInsurance,
        pensionScheme: pensionScheme,
        bankLoan: bankLoan,
      ),
    );
    Navigator.pushNamed(context, '/support-needs');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Activity & Finance'),
        backgroundColor: const Color(0xFF1BAEA6),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Estimated Weekly Sales *'),
            DropdownButtonFormField<String>(
              value: estimatedWeeklySales,
              decoration: const InputDecoration(hintText: 'Select sales'),
              items: salesOptions.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => estimatedWeeklySales = v),
              validator: (val) => val == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Number of Workers *'),
            DropdownButtonFormField<String>(
              value: numberOfWorkers,
              decoration: const InputDecoration(hintText: 'Select'),
              items: workerOptions.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => numberOfWorkers = v),
              validator: (val) => val == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Record Keeping Method *'),
            DropdownButtonFormField<String>(
              value: recordKeepingMethod,
              decoration: const InputDecoration(hintText: 'Select'),
              items: recordOptions.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => recordKeepingMethod = v),
              validator: (val) => val == null ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mobile Money Number (Optional)',
              ),
              keyboardType: TextInputType.phone,
              initialValue: mobileMoneyNumber,
              onChanged: (v) => setState(() => mobileMoneyNumber = v),
            ),
            const SizedBox(height: 16),
            const Text('Has Insurance? *'),
            Row(
              children: [
                Radio<String>(
                  value: 'yes',
                  groupValue: hasInsurance,
                  onChanged: (val) => setState(() => hasInsurance = val!),
                ),
                const Text('Yes'),
                Radio<String>(
                  value: 'no',
                  groupValue: hasInsurance,
                  onChanged: (val) => setState(() => hasInsurance = val!),
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Pension Scheme? *'),
            Row(
              children: [
                Radio<String>(
                  value: 'yes',
                  groupValue: pensionScheme,
                  onChanged: (val) => setState(() => pensionScheme = val!),
                ),
                const Text('Yes'),
                Radio<String>(
                  value: 'no',
                  groupValue: pensionScheme,
                  onChanged: (val) => setState(() => pensionScheme = val!),
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Has Bank Loan? *'),
            Row(
              children: [
                Radio<String>(
                  value: 'yes',
                  groupValue: bankLoan,
                  onChanged: (val) => setState(() => bankLoan = val!),
                ),
                const Text('Yes'),
                Radio<String>(
                  value: 'no',
                  groupValue: bankLoan,
                  onChanged: (val) => setState(() => bankLoan = val!),
                ),
                const Text('No'),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1BAEA6),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
