import 'package:agitha/ControllersFolder/DecorationController.dart';
import 'package:agitha/ModelsFoder/DecorationModel.dart';
import 'package:agitha/viewfolder/SubCompany/DecorationFolder.dart/ViewDecorationDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DecorationFormPage extends StatefulWidget {
  final DecorationModel? decoration;

  const DecorationFormPage({super.key, this.decoration});

  @override
  State<DecorationFormPage> createState() => _DecorationFormPageState();
}

class _DecorationFormPageState extends State<DecorationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _decorationDetailsController =
      TextEditingController();

  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    if (widget.decoration != null) {
      isEditMode = true;
      _eventNameController.text = widget.decoration!.eventName;
      _decorationDetailsController.text =
          widget.decoration!.decorationDetails;
    }
  }



  Future<void> submitDecoration() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
        Provider.of<DecorationProvider>(context, listen: false);

    if (isEditMode) {
      final updatedModel = DecorationModel(
        docId: widget.decoration!.docId,
        restauratId: widget.decoration!.restauratId,
        eventName: _eventNameController.text.trim(),
        decorationDetails: _decorationDetailsController.text.trim(),
      );

      await provider.updateDecoration(updatedModel);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Updated Successfully")));
    } else {
      final newModel = DecorationModel(
        docId: "",
        restauratId: "REST_ID", // 👉 replace with real id
        eventName: _eventNameController.text.trim(),
        decorationDetails: _decorationDetailsController.text.trim(),
      );

      await provider.addDecoration(newModel);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Added Successfully")));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final decorationProvider = Provider.of<DecorationProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Update Decoration" : "Add Decoration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    TextFormField(
                      controller: _eventNameController,
                      decoration: const InputDecoration(
                          labelText: "Event Name",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      
                      controller: _decorationDetailsController,
                      

                      maxLines: 5,
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                          labelText: "Decoration Details",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    


                   const SizedBox(height: 20),


                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                      backgroundColor:decorationProvider.isLoading?Colors.grey[100]: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                        onPressed: decorationProvider.isLoading
                            ? null
                            : submitDecoration,
                        child: decorationProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            :  Text(  isEditMode ? "Update":"Add",style: const TextStyle(color: Colors.white),),
                      ),
                    ),

              if (!isEditMode) 
                      InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>   DecorationListPage ()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 20,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "View Decoration List",
                            style: GoogleFonts.tinos(
                              fontSize: 15,
                              color: colorScheme.primary,
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              color: colorScheme.primary),
                        ],
                      ),
                    ),
                  ),


                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
