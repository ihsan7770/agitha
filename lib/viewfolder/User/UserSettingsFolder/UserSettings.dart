import 'package:agitha/viewfolder/User/UserSettingsFolder/HelpAndSupport.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/Languagepage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/RatingPage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/ReferAndEarn.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/TermsAndConditon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          _tile(
            icon: Icons.language,
            title: "Language",
            primary: primary,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LanguagePage()));
            },
          ),

          _divider(),

          _tile(
            icon: Icons.star_rate_rounded,
            title: "Ratings & Reviews",
            primary: primary,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RatingPage()));
            },
          ),

          _divider(),

          _tile(
            icon: Icons.card_giftcard,
            title: "Refer & Earn",
            primary: primary,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ReferEarnPage()));
            },
          ),

          _divider(),

          _tile(
            icon: Icons.support_agent,
            title: "Help & Support",
            primary: primary,
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HelpSupportPage()));
            },
          ),

          _divider(),

          _tile(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            primary: primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const TermsAndConditionsPage()),
              );
            },
          ),
           _divider(),
        ],
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required Color primary,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primary, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.tinos(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 28,
        color: Colors.grey,
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        thickness: 0.8,
        color: Colors.grey.shade300,
      ),
    );
  }
}
