import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/widgets/loader.dart';
import '../core/constants/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login({
      'login': _formData['identifier'],
      'password': _formData['password'],
    });

    setState(() => _loading = false);

    if (success && mounted && authProvider.user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.error ?? 'Login failed. Please try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body:
          _loading
              ? const Loader()
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 60,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Animate(
                      effects: [
                        FadeEffect(duration: 600.ms),
                        SlideEffect(begin: const Offset(0, -0.3)),
                      ],
                      child: Column(
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 72,
                            color: AppColors.green,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Welcome Back!",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Login to your account",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Animate(
                      effects: [
                        FadeEffect(duration: 500.ms),
                        SlideEffect(begin: const Offset(0, 0.2)),
                      ],
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Mobile or Email',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator:
                                      (v) =>
                                          v == null || v.trim().isEmpty
                                              ? 'Required'
                                              : null,
                                  onSaved:
                                      (v) =>
                                          _formData['identifier'] = v?.trim(),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                  validator:
                                      (v) =>
                                          v == null || v.length < 6
                                              ? 'Min 6 characters'
                                              : null,
                                  onSaved: (v) => _formData['password'] = v,
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _submit,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(context, '/register'),
                      child: const Text("Don't have an account? Register"),
                    ).animate().fadeIn(duration: 500.ms),
                  ],
                ),
              ),
    );
  }
}
