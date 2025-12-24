import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/InstructionController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyRegistration.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyResgistration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeliveryBoyInstructionsUser extends StatefulWidget {
  const DeliveryBoyInstructionsUser({super.key});

  @override
  State<DeliveryBoyInstructionsUser> createState() => _DeliveryBoyInstrutionsState();
}

class _DeliveryBoyInstrutionsState extends State<DeliveryBoyInstructionsUser> {
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
    final colorScheme = Theme.of(context).colorScheme;
    final instructionProvider = Provider.of<InstructionProvider>(context);
       final instructionList = instructionProvider.instructionList
              .where((instruction) => instruction.role == 'DeliveryBoy')
              .toList();

    return Scaffold(
      body: Stack(
        children: [
          /// Main scroll content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // space for bottom buttons
            child: 
            
            
            Column(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical:5),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    "Delivery partners are requested to read these instructions carefully before using the Agitha mobile application.",
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
                      MaterialPageRoute(builder: (_) => const DeliveryBoyRegistration()),
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
