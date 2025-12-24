import 'package:agitha/ControllersFolder/InstructionController.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/Addinstructions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantInstructions extends StatefulWidget {
  const RestaurantInstructions({super.key});

  @override
  State<RestaurantInstructions> createState() => _RestaurantInstructionsState();
}

class _RestaurantInstructionsState extends State<RestaurantInstructions> {
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

    void instructiondeleteAlert(String docId) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this Instruction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await instructionProvider.deleteInstruction(docId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("Instruction deleted successfully"),
                backgroundColor: colorScheme.primary,
              ));
              setState(() {}); // Refresh UI
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     final instructionProvider = Provider.of<InstructionProvider>(context);
       final instructionList = instructionProvider.instructionList
              .where((instruction) => instruction.role == 'Restaurant')
              .toList();

          if (instructionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator(

            ));
          }

          if (instructionList.isEmpty) {
            return const Center(child: 
            // CircularProgressIndicator(

            // ),
            
            Text("No Instruction uploaded yet.")
            );
          }

          return
     Scaffold(
     
      body:ListView.builder( padding: const EdgeInsets.all(16),
                  itemCount: instructionList.length,
                  itemBuilder: (context, index) {
                    final  instructions = instructionList[index];
  
                    return  Expanded(
                      child: Column(
                              children: [
                        
                        
                        
                        
                           // Section 1
                                     
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              "${index+1}.${instructions.title}",
                            style: GoogleFonts.tinos(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                     
                        
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
                         child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        instructions.instruction,
                          style: GoogleFonts.tinos(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                                        ),
                                      ),
                        
                        
                       
                       Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                              
                              children: [
                       
                               IconButton(
                               onPressed: () {
                                 Navigator.push(context, MaterialPageRoute(builder:(context)=>  AddInstructions(
                                  id: instructions.id,
                                    title: instructions.title,
                                    instruction: instructions.instruction,
                                    role: instructions.role,
                                  
                                 )));
                            
                               },
                               icon: const Icon(Icons.edit, color: Colors.blue),
                              
                             ),
                       
                       
                       
                                IconButton(
                                  onPressed: () =>
                                      instructiondeleteAlert(instructions.id!),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                        
                        
                        
                              ],
                        
                        
                        
                            ),
                    );
  
  
  
  
  
  
  
                  }  )
    
    );
  }
}