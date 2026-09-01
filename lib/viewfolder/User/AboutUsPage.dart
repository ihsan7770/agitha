import 'package:agitha/ControllersFolder/AboutOusController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AboutProvider>().fetchAboutData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final aboutProvider = Provider.of<AboutProvider>(context);
    final about = aboutProvider.aboutData;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: aboutProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : about == null
              ? const Center(child: Text("No data found."))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      /// 🔹 Top Image
                      Image.asset(
                        "assets/projectimages/Career.png",
                        fit: BoxFit.cover,
                        width: size.width,
                        height: size.height * 0.3,
                      ),

                      /// 🔹 About Section
                      Container(
                        width: size.width,
                        color: const Color.fromARGB(255, 253, 10, 10),
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "About Agitha",
                              style: GoogleFonts.tinos(
                                fontSize: size.width * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.02,
                              ),
                              child: Text(
                                about.about,
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 🔹 Our People
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          top: size.height * 0.03,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Our People",
                            style: GoogleFonts.tinos(
                              fontSize: size.width * 0.075,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.015,
                        ),
                        child: Text(
                          about.ourPeople,
                          style: TextStyle(
                            fontSize: size.width * 0.04,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      /// 🔹 Mission & Vision
                      Container(
                        width: size.width,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: size.width * 0.05,
                                ),
                                child: Text(
                                  "Mission and Vision",
                                  style: GoogleFonts.tinos(
                                    fontSize: size.width * 0.075,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.05,
                                vertical: size.height * 0.015,
                              ),
                              child: Text(
                                about.missionAndVision,
                                style: TextStyle(
                                  fontSize: size.width * 0.04,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 🔹 Word from Chairman
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: size.width * 0.05,
                            top: size.height * 0.02,
                          ),
                          child: Text(
                            "Word from Chairman",
                            style: GoogleFonts.tinos(
                              fontSize: size.width * 0.075,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              about.wordFromChairman,
                              style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                              maxLines: isExpanded ? null : 3,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),

                            SizedBox(height: size.height * 0.01),

                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? "Read Less" : "Read More",
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
