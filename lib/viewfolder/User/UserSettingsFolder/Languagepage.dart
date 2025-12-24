import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Languages',
                  style: GoogleFonts.tinos(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selected Language',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.red[900],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.flag, color: Colors.red, size: 25),
                        ),
                      ),
                      Text(
                        'English (US)',
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Transform.scale(
                          scale: 1.3,
                          child: Radio<String>(
                            activeColor: Colors.white,
                            fillColor: MaterialStateProperty.all(Colors.white),
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
                const SizedBox(height: 16),
                Text(
                  'All Languages',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: languages.length,
                    padding: const EdgeInsets.only(bottom: 80), // space for button
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.flag,
                                      color: Colors.red, size: 25),
                                ),
                              ),
                              Text(
                                languages[index],
                                style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Transform.scale(
                                  scale: 1.3,
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
            Positioned(
              bottom: 10,
              left: 16,
              right: 16,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
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
