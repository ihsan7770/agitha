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
    instructionProvider = Provider.of<InstructionProvider>(context, listen: false);

   
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

    return Scaffold(
      body: Stack(
        children: [
          /// Main scroll content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // space for bottom buttons
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 241, 2, 2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
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
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Hello!",
                          style: GoogleFonts.tinos(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        child: Text(
                          "Before you create an account, please read and accept our instructions.",
                          style: GoogleFonts.tinos(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Body content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Instructions",
                      style: GoogleFonts.tinos(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5 ),
                  child: Text(
                    "Please read these instructions carefully before using the Agitha mobile application as a restaurant partner",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                instructionProvider.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  :instructionProvider.instructionList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Center(child: Text("No Instructions uploaded yet.")),
                        )
                      :
                      
                       
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: instructionList.length,
                          itemBuilder: (context, index) {
                            final instructions = instructionList[index];

                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Section Title
                                  Text(
                                    "${index + 1}. ${instructions.title}",
                                    style: GoogleFonts.tinos(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  // Section Content
                                  Text(
                                    instructions.instruction,
                                    style: GoogleFonts.tinos(
                                      fontSize: 16,
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

                // Section 1
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       "1. Conditions of Use",
                //       style: GoogleFonts.tinos(
                //         fontSize: 22,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                //   child: Text(
                //     "The app is designed to provide a seamless and user-friendly experience, with all core features fully functional. It is stable and optimized for smooth performance across supported devices, ensuring minimal crashes or bugs. The user interface is intuitive, making navigation simple and efficient.",
                //     style: GoogleFonts.tinos(
                //       fontSize: 16,
                //       color: Colors.black,
                //       height: 1.5,
                //     ),
                //     textAlign: TextAlign.justify,
                //   ),
                // ),

                // // Section 2
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       "2. Use of the Service",
                //       style: GoogleFonts.tinos(
                //         fontSize: 22,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                //   child: Text(
                //     "The app is designed to provide a seamless and user-friendly experience, with all core features fully functional. It is stable and optimized for smooth performance across supported devices.",
                //     style: GoogleFonts.tinos(
                //       fontSize: 16,
                //       color: Colors.black,
                //       height: 1.5,
                //     ),
                //     textAlign: TextAlign.justify,
                //   ),
                // ),

                // // Section 3
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       "3. Privacy Policy",
                //       style: GoogleFonts.tinos(
                //         fontSize: 22,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                //   child: Text(
                //     "The app is designed to provide a seamless and user-friendly experience, ensuring user privacy and data protection through secure practices.",
                //     style: GoogleFonts.tinos(
                //       fontSize: 16,
                //       color: Colors.black,
                //       height: 1.5,
                //     ),
                //     textAlign: TextAlign.justify,
                //   ),
                // ),

                // // Section 4
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                //   child: Align(
                //     alignment: Alignment.topLeft,
                //     child: Text(
                //       "4. Termination",
                //       style: GoogleFonts.tinos(
                //         fontSize: 22,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                //   child: Text(
                //     "It is stable and optimized for smooth performance across supported devices, ensuring minimal crashes or bugs. The user interface is intuitive, making navigation simple and efficient.",
                //     style: GoogleFonts.tinos(
                //       fontSize: 16,
                //       color: Colors.black,
                //       height: 1.5,
                //     ),
                //     textAlign: TextAlign.justify,
                //   ),
                // ),
              ],
            ),
          ),

          /// Bottom stacked buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: colorScheme.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                         AuthenticationController().logout(context);
                      },
                      child: const Text(
                        "Decline",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                          Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const CompanyResgistration()),
                    );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Agree",
                        style: TextStyle(fontSize: 18),
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
