import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ufad/providers/language_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/gestures.dart';
import 'package:ufad/startup_&_onboarding/register.dart'; // ✅ Required for clickable span

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index == 1 && _tabController.indexIsChanging) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      const RegisterScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = Provider.of<LanguageProvider>(context).tr;
    final langProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔷 Header
          Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 80, bottom: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF007BFF),
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
                    Text(
                      tr('digitize'),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.2),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.5, curve: Curves.easeOut),

          const SizedBox(height: 16),

          // 🔘 Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF007BFF),
            labelColor: const Color(0xFF007BFF),
            unselectedLabelColor: Colors.black54,
            tabs: [Tab(text: tr('login')), Tab(text: tr('signup'))],
          ).animate().scaleY(begin: 0.8, end: 1, curve: Curves.easeOut),

          // 🧾 Form Fields
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: tr('phone_or_email'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ).animate(delay: 300.ms).fadeIn().slideX(begin: -0.2),
                        const SizedBox(height: 16),
                        TextFormField(
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: tr('password'),
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
                            child: Text(
                              tr('forgot_password'),
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
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
                              backgroundColor: const Color(0xFF007BFF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              tr('login'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.5),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                              children: [
                                Expanded(child: Divider(thickness: 1)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('or'),
                                ),
                                Expanded(child: Divider(thickness: 1)),
                              ],
                            )
                            .animate(delay: 700.ms)
                            .fadeIn()
                            .scaleXY(begin: 0.8, end: 1),
                        const SizedBox(height: 16),

                        // 🌐 Language Dropdown
                        DropdownButtonFormField<String>(
                          value: langProvider.locale.languageCode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(value: 'twi', child: Text('Twi')),
                            DropdownMenuItem(value: 'ha', child: Text('Hausa')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              langProvider.loadLanguage(value);
                              HapticFeedback.lightImpact();
                            }
                          },
                        ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.5),
                        const SizedBox(height: 20),

                        // 📜 Terms and Conditions (clickable)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: '${tr('by continuing')} ',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: tr('terms & conditions'),
                                style: const TextStyle(
                                  color: Colors.blue,
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
                const Center(child: SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
