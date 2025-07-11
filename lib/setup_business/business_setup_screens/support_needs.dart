import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/registration_provider.dart';

// This should match backend IDs for each support item!
const Map<String, int> supportNeedIds = {
  "Business registration": 1,
  "Loans / Funding": 2,
  "Record keeping": 3,
  "Market access": 4,
  "Training & coaching": 5,
  "Tax support": 6,
  "Pension / Insurance": 7,
};

class SupportNeedsScreen extends StatefulWidget {
  const SupportNeedsScreen({super.key});

  @override
  State<SupportNeedsScreen> createState() => _SupportNeedsScreenState();
}

class _SupportNeedsScreenState extends State<SupportNeedsScreen> {
  final List<String> supportItems = supportNeedIds.keys.toList();
  final Set<String> selectedSupportItems = {};

  void _onNext() {
    if (selectedSupportItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one support need.')),
      );
      return;
    }

    final supportIds =
        selectedSupportItems.map((e) => supportNeedIds[e]!).toList();
    // Save to provider
    final provider = Provider.of<RegistrationProvider>(context, listen: false);
    final registration = provider.registration;
    if (registration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing registration data!')),
      );
      return;
    }

    provider.setRegistration(registration.copyWith(supportNeeds: supportIds));

    Navigator.pushNamed(context, '/consent');
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4361EE);
    const backgroundColor = Color(0xFFF9F9F9);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: primaryColor,
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Support Needs",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4361EE), Color(0xFF3F37C9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select all that apply:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...supportItems.map(
                      (item) => CheckboxListTile(
                        title: Text(item),
                        value: selectedSupportItems.contains(item),
                        activeColor: primaryColor,
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
                          backgroundColor: primaryColor,
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
                    const SizedBox(height: 40),
                  ],
                ).animate().fadeIn().slideY(begin: 0.2, duration: 500.ms),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
