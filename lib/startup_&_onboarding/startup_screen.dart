import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/language_provider.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: Color(0xFF007BFF),
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
              Positioned(
                top: 50,
                right: 20,
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 28,
                ).animate().fadeIn(delay: 300.ms),
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
                      color: Colors.blue,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your business digitally with ease',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue),
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
                        backgroundColor: const Color(0xFF007BFF),
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
                        side: const BorderSide(color: Color(0xFF007BFF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Explore Features',
                        style: TextStyle(color: Color(0xFF007BFF)),
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
                  Consumer<LanguageProvider>(
                    builder: (context, langProvider, child) {
                      return DropdownButtonFormField<String>(
                        value: langProvider.locale.languageCode,
                        decoration: const InputDecoration(
                          labelText: 'Select Language',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'twi', child: Text('Twi')),
                          DropdownMenuItem(value: 'ha', child: Text('Hausa')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            langProvider.loadLanguage(value);
                          }
                        },
                      );
                    },
                  ).animate().fadeIn(delay: 800.ms),
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
