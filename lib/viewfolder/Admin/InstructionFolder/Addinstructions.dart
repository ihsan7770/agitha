import 'package:agitha/ControllersFolder/InstructionController.dart';
import 'package:agitha/ModelsFoder/InstructionModel.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/InstructionTabBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddInstructions extends StatefulWidget {
    final String? title;
  final String? instruction;
  final String? role; 
  final String? id;
  const AddInstructions({
    super.key,
    this.title,
    this.instruction,
    this.role,
    this.id,
    });

  @override
  State<AddInstructions> createState() => _AddInstructionsState();
}

class _AddInstructionsState extends State<AddInstructions> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
    String? _selectedRole;
    bool restourentloading = false;
    bool deliveryboyLoading = false;


    void submitInstruction() async {
          final colorScheme = Theme.of(context).colorScheme;
       final instructionProvider =
        Provider.of<InstructionProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      final instruction = InstructionModel(
        title: _titleController.text.trim(),
        instruction: _descriptionController.text.trim(),
        role: _selectedRole ?? widget.role!,
      );
        await instructionProvider.AddInstructions(instruction);
          _titleController.clear();
          _descriptionController.clear();
         ScaffoldMessenger.of(context)
             .showSnackBar(SnackBar(
                 content:  Text(
                     "Instruction for $_selectedRole added successfully"),
                     backgroundColor: colorScheme.primary ,
                     )
                   
                     
                     );
    }}


   void updateInstruction() async {
  final colorScheme = Theme.of(context).colorScheme;
  final instructionProvider = Provider.of<InstructionProvider>(context, listen: false);

  if (!_formKey.currentState!.validate()) return;

  if (widget.id == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error: Instruction ID not found.")),
    );
    return;
  }

  try {
    final instruction = InstructionModel(
      title: _titleController.text.trim(),
      instruction: _descriptionController.text.trim(),
      role: _selectedRole ?? widget.role!,
    );

    await instructionProvider.updateinstructions(widget.id!, instruction);
   _titleController.clear();
   _descriptionController.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Instruction for ${widget.role} updated successfully"),
          backgroundColor: colorScheme.primary,
        ),
      );

      Navigator.pop(context); // ✅ Go back after success
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error updating instruction: $e")),
    );

  }
}







     @override
  void initState() {
    super.initState();
    _titleController .text = widget.title ?? "";
    _descriptionController .text = widget.instruction ?? "";
  }

  @override
  void dispose() {
   _titleController.dispose();
   _descriptionController.dispose();
    super.dispose();
  }
    bool get isEditMod => widget.id != null;


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final instructionProvider = Provider.of<InstructionProvider>(context);

    String heading ;
    if(widget.role == "Restaurant"){
      heading = "Edit Restaurant Instructions";
    } else if (widget.role == "DeliveryBoy"){
      heading = "Edit Delivery Instructions";
    } else {
      heading = "Add Instructions";
    }

    return Scaffold(
      appBar: AppBar(
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: GoogleFonts.tinos(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Small single-line field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Instruction Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Multi-line field (4 lines)
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Instruction Description",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Two Buttons Row

               Visibility(
                 visible:widget.role == "Restaurant" || widget.role == "DeliveryBoy",
                 child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: instructionProvider.isLoading
                                  ? Colors.grey
                                  : colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: (){
                       
                        updateInstruction();
                      },
                      child:  instructionProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
               ),

             
              Visibility(
                 visible:widget.role !="Restaurant" && widget.role != "DeliveryBoy",

                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                     
                            setState(() {
                              _selectedRole = 'Restaurant';
                                
                            });
                            submitInstruction();
                         
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: restourentloading
                                  ? Colors.grey
                                  : colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: restourentloading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                :  const Text(
                          "Send to Restaurant",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                     
                           setState(() {
                              _selectedRole = 'DeliveryBoy';
                            
                              
                            });

                            submitInstruction();
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  deliveryboyLoading
                                  ? Colors.grey
                                  : colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:  deliveryboyLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                          "Send to DeliveryBoy",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

            
              Visibility(
                visible:widget.role !="Restaurant" && widget.role != "DeliveryBoy",
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const InstructionTabBar()),); 
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "View all Instructions",
                          style: GoogleFonts.tinos(
                            fontSize: 15,
                            color: colorScheme.primary,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: colorScheme.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
