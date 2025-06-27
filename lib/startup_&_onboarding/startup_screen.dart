import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brandGreen = Color(0xFF1BAEA6);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: brandGreen, // 🔴 Use brand color!
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'UFAD',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                    const Text(
                      'AFRICA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 4),
                    const Text(
                      'Digitize Your Business',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/onb.png',
                    height: 180,
                    frameBuilder: (
                      context,
                      child,
                      frame,
                      wasSynchronouslyLoaded,
                    ) {
                      return frame == null
                          ? const CircularProgressIndicator()
                          : child;
                    },
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.error,
                          size: 100,
                          color: Colors.red,
                        ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome to UFAD Africa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: brandGreen, // 🔴 Use brand color!
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your business digitally with ease',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: brandGreen), // 🔴 Use brand color!
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/owner-info',
                        ).then((_) => HapticFeedback.lightImpact());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen, // 🔴 Use brand color!
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Set Up Your Business',
                        style: TextStyle(color: Colors.white),
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/login',
                        ).then((_) => HapticFeedback.lightImpact());
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: brandGreen), // 🔴
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Explore Features',
                        style: TextStyle(color: brandGreen), // 🔴
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/guest-home',
                      ).then((_) => HapticFeedback.lightImpact());
                    },
                    child: const Text(
                      'Continue as Guest',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ).animate().fadeIn(delay: 750.ms),
                  const SizedBox(height: 20),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
