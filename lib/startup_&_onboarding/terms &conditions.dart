import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF007BFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitle('1. Acceptance of Terms'),
            SectionText(
              'By using the UFAD Africa app, you agree to these terms. '
              'If you do not agree, please do not use the app.',
            ),
            SectionTitle('2. User Responsibilities'),
            SectionText(
              'You are responsible for safeguarding your account. Do not misuse the app or its services.',
            ),
            SectionTitle('3. Data Collection & Usage'),
            SectionText(
              'We collect minimal data necessary to provide the service. Your data is protected and not shared without consent.',
            ),
            SectionTitle('4. Intellectual Property'),
            SectionText(
              'All materials in this app are owned by UFAD Africa and may not be reproduced without permission.',
            ),
            SectionTitle('5. Limitations'),
            SectionText(
              'UFAD Africa is not responsible for any damages caused by the use of this app.',
            ),
            SectionTitle('6. Changes to Terms'),
            SectionText(
              'We may update these terms. Continued use of the app implies acceptance of the latest terms.',
            ),
            SectionTitle('7. Contact'),
            SectionText(
              'If you have questions, contact us at: support@ufadafrica.com',
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                'Thank you for using UFAD Africa!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF007BFF),
        ),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
    );
  }
}
