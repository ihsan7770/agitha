import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(
                'Terms & Conditions',
                style: GoogleFonts.tinos(
                    fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Acceptance of Terms',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'By using this app, you agree to comply with and be bound by these terms and conditions.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '2. User Responsibilities',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You are responsible for providing accurate information and not misusing the app for illegal activities.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '3. Privacy',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your data is collected and used according to our Privacy Policy. Please review it carefully.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '4. Intellectual Property',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All content, logos, and software in this app are the property of the app owner and protected by copyright laws.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '5. Limitation of Liability',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The app owner is not responsible for any damages or losses incurred by using this app.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '6. Changes to Terms',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We may update these terms periodically. Users will be notified of changes.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
