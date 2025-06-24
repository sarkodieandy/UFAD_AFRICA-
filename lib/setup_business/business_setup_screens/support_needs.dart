import 'package:flutter/material.dart';

class SupportNeedsScreen extends StatefulWidget {
  const SupportNeedsScreen({super.key});

  @override
  State<SupportNeedsScreen> createState() => _SupportNeedsScreenState();
}

class _SupportNeedsScreenState extends State<SupportNeedsScreen> {
  final List<String> supportItems = [
    "Business registration",
    "Loans / Funding",
    "Record keeping",
    "Market access",
    "Training & coaching",
    "Tax support",
    "Pension / Insurance",
  ];
  final Set<String> selectedSupportItems = {};

  void _onNext() {
    // Optionally, save the selectedSupportItems to provider
    Navigator.pushNamed(context, '/consent');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Needs'),
        backgroundColor: const Color(0xFF4361EE),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          const Text(
            "Select all that apply:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...supportItems.map(
            (item) => CheckboxListTile(
              title: Text(item),
              value: selectedSupportItems.contains(item),
              activeColor: const Color(0xFF4361EE),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selectedSupportItems.add(item);
                  } else {
                    selectedSupportItems.remove(item);
                  }
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4361EE),
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
    );
  }
}
