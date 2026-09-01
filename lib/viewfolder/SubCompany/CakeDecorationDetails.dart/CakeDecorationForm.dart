import 'package:agitha/ControllersFolder/CakeDecorationController.dart';
import 'package:agitha/ModelsFoder/CakeDecorationModel.dart';
import 'package:agitha/viewfolder/SubCompany/CakeDecorationDetails.dart/ListCakeDecorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CakeDecorationFormPage extends StatefulWidget {
  final CakeDecorationModel? decoration;
  const CakeDecorationFormPage({super.key, this.decoration});

  @override
  State<CakeDecorationFormPage> createState() => _CakeDecorationFormPageState();
  
}
  
class _CakeDecorationFormPageState extends State<CakeDecorationFormPage> {
    final _formKey = GlobalKey<FormState>();
    bool isEditMode = false;

  final TextEditingController _cakeDecorationController = TextEditingController();
  final TextEditingController _priceDetailsController =
      TextEditingController();

        @override
  void initState() {
    super.initState();

    if (widget.decoration != null) {
      isEditMode = true;
      _cakeDecorationController.text = widget.decoration!.decorationDetails;
      _priceDetailsController.text =
          widget.decoration!.decorationPrice;
    }
  }

   Future<void> submitDecoration() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
        Provider.of<CakeDecorationProvider>(context, listen: false);

    if (isEditMode) {
      final updatedModel = CakeDecorationModel(
        docId: widget.decoration!.docId,
        restauratId: widget.decoration!.restauratId,
        
        decorationDetails: _cakeDecorationController.text.trim(),
        decorationPrice: _priceDetailsController.text.trim(),
      );

      await provider.updateDecoration(updatedModel);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Updated Successfully")));
    } else {
      final newModel = CakeDecorationModel(
        docId: "",
        restauratId: "REST_ID", // 👉 replace with real id
        decorationDetails: _cakeDecorationController.text.trim(),
        decorationPrice: _priceDetailsController.text.trim(),
      );

      await provider.addDecoration(newModel);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Added Successfully")));
    }

    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cakedecorationProvider = Provider.of<CakeDecorationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? "Update Cake Decoration" : "Add Cake Decoration"),
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
                      controller: _cakeDecorationController,
                      decoration: const InputDecoration(
                          labelText: "Cake Decoration",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      
                      controller: _priceDetailsController,
                      

                      
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                          labelText: "Price",
                          border: OutlineInputBorder()),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Required" : null,
                    ),
                    


                   const SizedBox(height: 20),


                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                      backgroundColor:cakedecorationProvider.isLoading?Colors.grey[100]: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                        onPressed: cakedecorationProvider.isLoading
                            ? null
                            : submitDecoration,
                        child: cakedecorationProvider.isLoading
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
                            builder: (context) =>  CakeDecorationListPage ()),
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