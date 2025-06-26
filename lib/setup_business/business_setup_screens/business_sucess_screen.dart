import 'package:flutter/material.dart';

class BusinessRegistrationSuccessScreen extends StatelessWidget {
  const BusinessRegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text(
                "Registration Complete!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your business registration has been submitted successfully.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/dashboard', // <--- NAVIGATE TO DASHBOARD HERE
                      (_) => false,
                    ),
                child: const Text("Go to Dashboard"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
