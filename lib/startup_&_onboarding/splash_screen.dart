import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashAnimationConfig {
  static const brandGreen = Color(0xFF1BAEA6);
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                'assets/app_icon.png',
                height: size.height * 0.18,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'UFAD Africa',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: _SplashAnimationConfig.brandGreen,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Text(
                  'Digitize Your Business',
                  style: TextStyle(
                    fontSize: 16,
                    color: _SplashAnimationConfig.brandGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Loader with pulse
            FadeTransition(
              opacity: _fadeAnimation,
              child: const PulseAnimation(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _SplashAnimationConfig.brandGreen,
                  ),
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pulse effect for loader
class PulseAnimation extends StatefulWidget {
  final Widget child;
  const PulseAnimation({super.key, required this.child});

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.85, end: 1.15).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
