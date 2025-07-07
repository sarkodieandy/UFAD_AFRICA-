import 'package:flutter/material.dart';

class BusinessRegistrationSuccessScreen extends StatelessWidget {
  const BusinessRegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 24),
              Text(
                'Registration Complete!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your business registration has been submitted successfully.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  ),
                  icon: const Icon(Icons.dashboard),
                  label: const Text('Go to Dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
