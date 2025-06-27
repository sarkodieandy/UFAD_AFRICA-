import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  static const brandGreen = Color(0xFF1BAEA6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with brand color
          Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                decoration: const BoxDecoration(
                  color: brandGreen,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'UFAD',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().scaleXY(
                      begin: 0.8,
                      end: 1,
                      curve: Curves.elasticOut,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AFRICA',
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ).animate(delay: 100.ms).fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 8),
                    const Text(
                      'Digitize Your Business',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.2),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.5, curve: Curves.easeOut),

          const SizedBox(height: 30),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Phone or Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon:
                              Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ).animate().scale(),
                          onPressed: () {
                            setState(() => _obscureText = !_obscureText);
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ),
                    ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.2),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => HapticFeedback.lightImpact(),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: brandGreen, fontSize: 13),
                        ),
                      ).animate(delay: 500.ms).fadeIn().slideY(begin: 0.5),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            HapticFeedback.lightImpact();
                            Navigator.pushReplacementNamed(
                              context,
                              '/dashboard',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandGreen,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.5),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                          children: [
                            Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(''),
                            ),
                            Expanded(child: Divider(thickness: 1)),
                          ],
                        )
                        .animate(delay: 700.ms)
                        .fadeIn()
                        .scaleXY(begin: 0.8, end: 1),
                    const SizedBox(height: 16),

                    // You can add more widgets here (e.g. social login, language, etc)
                    const SizedBox(height: 20),

                    // Terms and Conditions (clickable)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By continuing you agree to ',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: 'terms & conditions',
                            style: const TextStyle(
                              color: brandGreen,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/terms');
                                    HapticFeedback.lightImpact();
                                  },
                          ),
                        ],
                      ),
                    ).animate(delay: 900.ms).fadeIn().slideY(begin: 0.5),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
