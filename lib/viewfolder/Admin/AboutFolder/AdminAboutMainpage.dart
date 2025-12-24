

import 'package:agitha/ControllersFolder/AboutOusController.dart';
import 'package:agitha/viewfolder/Admin/AboutFolder/AboutFormFeild.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

    if (aboutProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final about = aboutProvider.aboutData;

    if (about == null) {
      return const Center(child: Text("No data found."));
    }
    final colorScheme = Theme.of(context).colorScheme;

   
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                about.about,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(colorScheme.primary)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutFormField(
                          title: "About Us",
                          label: "About Us",
                          // initialText: "",
                        ),
                      ),
                    );
                  },
                  child: const Text("Edit",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                about.ourPeople,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(colorScheme.primary)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutFormField(
                          title: "Our People",
                          label: "Our People",
                          // initialText: about.ourPeople,
                        ),
                      ),
                    );
                  },
                  child: const Text("Edit",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

           
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                about.missionAndVision,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(colorScheme.primary)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutFormField(
                          title: "Mission and Vision",
                          label: "Mission and Vision",
                          // initialText: about.missionAndVision,
                        ),
                      ),
                    );
                  },
                  child: const Text("Edit",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

           
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    about.wordFromChairman,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: isExpanded ? null : 3,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      isExpanded ? "Read Less" : "Read More",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 30.0),
                child:  ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(colorScheme.primary)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutFormField(
                          title: "Word from Chairman",
                          label: "Word from Chairman",
                          // initialText:about.wordFromChairman ,
                        ),
                      ),
                    );
                  },
                  child: const Text("Edit",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
