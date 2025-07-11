import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
              // Animated check icon
              const Icon(Icons.check_circle, color: Colors.green, size: 100)
                  .animate()
                  .scaleXY(begin: 0.5, end: 1, duration: 600.ms)
                  .fadeIn(duration: 600.ms),
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
                    '/login', // If you want to go to dashboard, change to '/dashboard'
                    (_) => false,
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Go to Login'),
                ),
              ),
              // Optional: Add a "Back" or "Close" link
              const SizedBox(height: 18),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Back",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
