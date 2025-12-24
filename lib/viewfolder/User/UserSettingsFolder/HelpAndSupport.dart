import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
                'Help & Support',
                style: GoogleFonts.tinos(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1. Contact Us',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For any help, you can reach our support team anytime via email at support@example.com or call us at +91 98765 43210.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '2. Frequently Asked Questions (FAQs)',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Visit the FAQs section in the app for quick answers to common issues.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '3. Report an Issue',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Facing technical problems? You can report them under the "Report a Problem" section in the app.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '4. Feedback',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We value your suggestions! Share your feedback to help us improve your experience.',
                        style: GoogleFonts.tinos(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '5. Service Hours',
                        style: GoogleFonts.tinos(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our support team is available Monday to Saturday, 9 AM – 7 PM IST. Please allow up to 24 hours for responses.',
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
