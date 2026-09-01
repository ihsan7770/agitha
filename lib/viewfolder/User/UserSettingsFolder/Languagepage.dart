import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? selectedTime;

  final List<String> languages = [
    "English",
    "Hindi",
    "Spanish",
    "French",
    "German",
    "Arabic",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Title
                Text(
                  'Languages',
                  style: GoogleFonts.tinos(
                    fontSize: size.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: size.height * 0.01),

                Text(
                  'Selected Language',
                  style: GoogleFonts.roboto(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: size.height * 0.015),

                /// 🔹 Selected Language Card
                Container(
                  height: size.height * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.width * 0.03),
                        child: CircleAvatar(
                          radius: size.width * 0.07,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.flag,
                            color: Colors.red,
                            size: size.width * 0.06,
                          ),
                        ),
                      ),

                      Text(
                        'English (US)',
                        style: GoogleFonts.roboto(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: EdgeInsets.all(size.width * 0.04),
                        child: Transform.scale(
                          scale: size.width * 0.0035,
                          child: Radio<String>(
                            activeColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.all(Colors.white),
                            value: "English (US)",
                            groupValue: selectedTime,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (value) {
                              setState(() => selectedTime = value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                /// 🔹 All Languages
                Text(
                  'All Languages',
                  style: GoogleFonts.roboto(
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: size.height * 0.015),

                /// 🔹 Language List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: size.height * 0.12,
                    ),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                        ),
                        child: Container(
                          height: size.height * 0.12,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(size.width * 0.03),
                                child: CircleAvatar(
                                  radius: size.width * 0.07,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.flag,
                                    color: Colors.red,
                                    size: size.width * 0.06,
                                  ),
                                ),
                              ),

                              Text(
                                languages[index],
                                style: GoogleFonts.roboto(
                                  fontSize: size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),

                              const Spacer(),

                              Padding(
                                padding: EdgeInsets.all(size.width * 0.04),
                                child: Transform.scale(
                                  scale: size.width * 0.0035,
                                  child: Radio<String>(
                                    activeColor: Colors.black,
                                    fillColor:
                                        MaterialStateProperty.all(Colors.black),
                                    value: languages[index],
                                    groupValue: selectedTime,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      setState(() => selectedTime = value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            /// 🔹 Save Button
            Positioned(
              bottom: size.height * 0.015,
              left: size.width * 0.04,
              right: size.width * 0.04,
              child: SizedBox(
                height: size.height * 0.065,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: size.width * 0.045),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
