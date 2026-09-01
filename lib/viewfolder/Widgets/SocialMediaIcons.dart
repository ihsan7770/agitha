import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    final double iconRadius = size.width * 0.06; // responsive
    final double iconSize = size.width * 0.06;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Instagram
          InkWell(
            onTap: () => _launchUrl("https://www.instagram.com/"),
            child: CircleAvatar(
              backgroundColor: Colors.red[100],
              radius: iconRadius,
              child: FaIcon(
                FontAwesomeIcons.instagram,
                color: colorScheme.primary,
                size: iconSize,
              ),
            ),
          ),

          SizedBox(width: size.width * 0.02),

          /// Facebook
          InkWell(
            onTap: () => _launchUrl("https://www.facebook.com/"),
            child: CircleAvatar(
              backgroundColor: Colors.red[100],
              radius: iconRadius,
              child: FaIcon(
                FontAwesomeIcons.facebook,
                color: colorScheme.primary,
                size: iconSize,
              ),
            ),
          ),

          SizedBox(width: size.width * 0.02),

          /// Twitter (X)
          InkWell(
            onTap: () => _launchUrl("https://twitter.com/"),
            child: CircleAvatar(
              backgroundColor: Colors.red[100],
              radius: iconRadius,
              child: FaIcon(
                FontAwesomeIcons.twitter,
                color: colorScheme.primary,
                size: iconSize,
              ),
            ),
          ),

          SizedBox(width: size.width * 0.02),

          /// Pinterest
          InkWell(
            onTap: () => _launchUrl("https://www.pinterest.com/"),
            child: CircleAvatar(
              backgroundColor: Colors.red[100],
              radius: iconRadius,
              child: FaIcon(
                FontAwesomeIcons.pinterest,
                color: colorScheme.primary,
                size: iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
