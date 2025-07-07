import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                        onPressed: () {
                          Navigator.pushNamed(context, '/consent');
                        },
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
