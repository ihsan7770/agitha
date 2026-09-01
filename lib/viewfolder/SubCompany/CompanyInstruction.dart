import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/InstructionController.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyResgistration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompanyInstrutions extends StatefulWidget {
  const CompanyInstrutions({super.key});

  @override
  State<CompanyInstrutions> createState() => _CompanyInstrutionsState();
}

class _CompanyInstrutionsState extends State<CompanyInstrutions> {
  late InstructionProvider instructionProvider;

  @override
  void initState() {
    super.initState();
    instructionProvider =
        Provider.of<InstructionProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await instructionProvider.fetchAllInstruction();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final instructionProvider = Provider.of<InstructionProvider>(context);
    final instructionList = instructionProvider.instructionList
        .where((instruction) => instruction.role == 'Restaurant')
        .toList();

    final colorScheme = Theme.of(context).colorScheme;

    // ✅ MediaQuery added
    final media = MediaQuery.of(context);
    final height = media.size.height;
    final width = media.size.width;

    return Scaffold(
      body: Stack(
        children: [
          /// Main scroll content
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: height * 0.15),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 2, 2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(width * 0.06),
                      bottomRight: Radius.circular(width * 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back,
                              color: Colors.white, size: width * 0.07),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04),
                        child: Text(
                          "Hello!",
                          style: GoogleFonts.tinos(
                            fontSize: width * 0.075,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                            vertical: height * 0.015),
                        child: Text(
                          "Before you create an account, please read and accept our instructions.",
                          style: GoogleFonts.tinos(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.03),

                /// Instructions Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Instructions",
                      style: GoogleFonts.tinos(
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.01),
                  child: Text(
                    "Please read these instructions carefully before using the Agitha mobile application as a restaurant partner",
                    style: GoogleFonts.tinos(
                      fontSize: width * 0.04,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                /// Loading / Empty / List
                instructionProvider.isLoading
                    ? Padding(
                        padding: EdgeInsets.all(width * 0.1),
                        child: const Center(
                            child: CircularProgressIndicator()),
                      )
                    : instructionList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(width * 0.1),
                            child: const Center(
                                child: Text(
                                    "No Instructions uploaded yet.")),
                          )
                        : ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: instructionList.length,
                            itemBuilder: (context, index) {
                              final instructions =
                                  instructionList[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.04,
                                  right: width * 0.04,
                                  top: height * 0.01,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${index + 1}. ${instructions.title}",
                                      style: GoogleFonts.tinos(
                                        fontSize: width * 0.055,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.005),
                                    Text(
                                      instructions.instruction,
                                      style: GoogleFonts.tinos(
                                        fontSize: width * 0.04,
                                        color: Colors.black,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),

          /// Bottom Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.02,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02),
                        side: BorderSide(
                            color: colorScheme.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(width * 0.03),
                        ),
                      ),
                      onPressed: () {
                        AuthenticationController().logout(context);
                      },
                      child: Text(
                        "Decline",
                        style:
                            TextStyle(fontSize: width * 0.045),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const CompanyResgistration()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.02),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(width * 0.03),
                        ),
                      ),
                      child: Text(
                        "Agree",
                        style:
                            TextStyle(fontSize: width * 0.045),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}