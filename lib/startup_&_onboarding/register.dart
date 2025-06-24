import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/language_provider.dart';
import 'package:flutter/gestures.dart'; // ✅ Required for clickable span

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final primaryBlue = const Color(0xFF007BFF);
  final lightBlue = const Color(0xFFE6F0FF);

  @override
  Widget build(BuildContext context) {
    final tr = Provider.of<LanguageProvider>(context).tr;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔵 Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 80, bottom: 40),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'UFAD',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ).animate().scaleXY(begin: 0.8, end: 1),
                const SizedBox(height: 4),
                const Text(
                  'AFRICA',
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 3,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ).animate(delay: 100.ms).fadeIn(),
                const SizedBox(height: 8),
                Text(
                  tr('digitize'),
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ).animate(delay: 200.ms).fadeIn(),
              ],
            ),
          ),

          // 📄 Registration Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 30),

                    // 🔘 Social Logins
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Image.asset('assets/google.png', height: 24),
                            label: const Text('Google'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                          ).animate().slideX(begin: -0.2),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: Image.asset(
                              'assets/facebook.png',
                              height: 24,
                            ),
                            label: const Text('Facebook'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                          ).animate().slideX(begin: 0.2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🧾 Form Fields
                    _buildTextField(tr('full name'), Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildTextField(tr('phone or email'), Icons.email_outlined),
                    const SizedBox(height: 16),
                    _buildTextField(
                      tr('password'),
                      Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Confirm Password',
                      Icons.lock_outline,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pushNamed(context, '/otp-verification');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          tr('register'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ).animate().scaleXY(delay: 200.ms),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Terms & Conditions (clickable)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: '${tr('agree terms')} ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: tr('terms conditions'),
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/terms');
                                  },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 👥 Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryBlue),
        filled: true,
        fillColor: lightBlue.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
