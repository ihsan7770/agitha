import 'package:agitha/viewfolder/Widgets/ContactTextFormContainer.dart';
import 'package:agitha/viewfolder/Widgets/SocialMediaIcons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Image
            Image.asset(
              "assets/projectimages/Career.png",
              width: size.width,
              height: size.height * 0.25,
              fit: BoxFit.cover,
            ),

            /// 🔹 Contact Information Section
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contacts Information",
                    style: GoogleFonts.tinos(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: size.height * 0.015),

                  Text(
                    "We're here to answer any questions you may have "
                    "about our products, services, or company. Reach "
                    "out to us and we'll respond as soon as we can.",
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  /// 📍 Address
                  Row(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.06,
                        backgroundColor: Colors.red[100],
                        child: Icon(
                          Icons.location_on_outlined,
                          size:size.width * 0.07 ,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Text(
                          "AL SHARQIA TOWER",
                          style: GoogleFonts.tinos(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// ✉️ Email
                  Row(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.06,
                        backgroundColor: Colors.red[100],
                        child: Icon(
                          Icons.mail_outline,
                           size:size.width * 0.07 ,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Expanded(
                        child: Text(
                          "INFO@AGTHIA.FOOD.COM.KW",
                          style: GoogleFonts.tinos(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),

                  /// 📞 Phone
                  Row(
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.06,
                        backgroundColor: Colors.red[100],
                        child: Icon(
                          Icons.phone_outlined,
                           size:size.width * 0.07 ,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: size.width * 0.04),
                      Text(
                        "22260445",
                        style: GoogleFonts.tinos(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.04),

                  const Center(child: SocialMediaIcons()),
                ],
              ),
            ),

            /// 🔹 Have a Question
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.03,
              ),
              child: Text(
                "Have a Question?",
                style: GoogleFonts.tinos(
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),

            /// 🔹 Contact Form
            const ContactTextFromContainer(),

            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}
