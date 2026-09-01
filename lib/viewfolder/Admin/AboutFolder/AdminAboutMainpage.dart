import 'package:agitha/ControllersFolder/AboutOusController.dart';
import 'package:agitha/viewfolder/Admin/AboutFolder/AboutFormFeild.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminAboutMainPage extends StatefulWidget {
  const AdminAboutMainPage({super.key});

  @override
  State<AdminAboutMainPage> createState() => _AdminAboutMainPageState();
}

class _AdminAboutMainPageState extends State<AdminAboutMainPage> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AboutProvider>(context, listen: false).fetchAboutData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final aboutProvider = Provider.of<AboutProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    // ✅ LOADING STATE (WHITE SCREEN FIX)
    if (aboutProvider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final about = aboutProvider.aboutData;

    // ✅ EMPTY STATE
    if (about == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text("No data found."),
        ),
      );
    }

    // ✅ MAIN UI
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ABOUT US
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "About us",
                style: GoogleFonts.tinos(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                about.about,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AboutFormField(
                          title: "About Us",
                          label: "About Us",
                        ),
                      ),
                    );
                  },
                  child:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            // OUR PEOPLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Our People",
                style: GoogleFonts.tinos(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                about.ourPeople,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AboutFormField(
                          title: "Our People",
                          label: "Our People",
                        ),
                      ),
                    );
                  },
                  child:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            // MISSION AND VISION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Mission and Vision",
                style: GoogleFonts.tinos(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                about.missionAndVision,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AboutFormField(
                          title: "Mission and Vision",
                          label: "Mission and Vision",
                        ),
                      ),
                    );
                  },
                  child:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            // WORD FROM CHAIRMAN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Word from Chairman",
                style: GoogleFonts.tinos(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                about.wordFromChairman,
                maxLines: isExpanded ? null : 3,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? "Read Less" : "Read More",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(colorScheme.primary),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AboutFormField(
                          title: "Word from Chairman",
                          label: "Word from Chairman",
                        ),
                      ),
                    );
                  },
                  child:
                      const Text("Edit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
