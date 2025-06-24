import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsRemaining = 30;
  late final Timer _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter all 6 digits'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    if (!mounted) return;
    setState(() => _isVerifying = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('OTP Verified Successfully!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _resendOtp() {
    setState(() {
      _secondsRemaining = 30;
    });
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('OTP resent successfully'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
          width: 48,
          height: 60,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color:
                      _focusNodes[index].hasFocus
                          ? const Color(0xFF007BFF)
                          : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF007BFF),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
              if (value.isNotEmpty && index == 5) {
                FocusScope.of(context).unfocus();
              }
            },
          ),
        )
        .animate(delay: (100 * index).ms)
        .slideX(begin: 0.5, curve: Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP').animate().fadeIn().slideX(begin: -0.1),
        centerTitle: true,
        backgroundColor: const Color(0xFF007BFF),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Icon(
              Icons.verified_user_rounded,
              size: 60,
              color: Color(0xFF007BFF),
            ).animate().scaleXY(begin: 0.8, end: 1, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            const Text(
              'Enter the 6-digit code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideY(begin: 0.5),
            const SizedBox(height: 8),
            const Text(
              'Sent to your phone or email',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ).animate().fadeIn().slideY(begin: 0.5),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _buildOtpBox),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  shadowColor: const Color(0xFF007BFF).withOpacity(0.3),
                ),
                child:
                    _isVerifying
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'VERIFY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.5),
            ),
            const SizedBox(height: 20),
            Text(
              _secondsRemaining > 0
                  ? 'Resend OTP in $_secondsRemaining seconds'
                  : 'Didn\'t receive the code?',
              style: const TextStyle(color: Colors.grey),
            ).animate().fadeIn(delay: 500.ms),
            if (_secondsRemaining == 0)
              TextButton(
                onPressed: _resendOtp,
                child: const Text(
                  'RESEND OTP',
                  style: TextStyle(
                    color: Color(0xFF007BFF),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
