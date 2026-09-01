import 'package:agitha/ControllersFolder/MediaController.dart';
import 'package:agitha/ModelsFoder/MediaModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'CurrentNewsUploaded.dart';

class MediaFormField extends StatefulWidget {
  final String? news;
  final String? link;
  final String? id;

  const MediaFormField({super.key, this.news, this.link, this.id});

  @override
  State<MediaFormField> createState() => _MediaFormFieldState();
}

class _MediaFormFieldState extends State<MediaFormField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _NewsController = TextEditingController();
  final TextEditingController _News_Link_Controller = TextEditingController();

  bool get isEditMode => widget.id != null;

  void submitMedia()async{
     final mediaProvider = Provider.of<MediaProvider>(context, listen: false);

            final colorScheme = Theme.of(context).colorScheme;


 if (_formKey.currentState!.validate()) {
        
         final media = MediaModel(
           news: _NewsController.text.trim(),
           link: _News_Link_Controller.text.trim(),
         );

       if (isEditMode) {
         // Update existing document
         await mediaProvider.updateMedia(
             widget.id!, media);
         ScaffoldMessenger.of(context)
             .showSnackBar(SnackBar(
                 content: const Text(
                     "Media updated successfully"),
                        backgroundColor: colorScheme.primary ,
                     ));
       } else {
         // Add new document
         await mediaProvider.addMedia(media);
         ScaffoldMessenger.of(context)
             .showSnackBar(SnackBar(
                 content: const Text(
                     "Media added successfully"),
                     backgroundColor: colorScheme.primary ,
                     )
                   
                     
                     );
       }  Navigator.pop(context);
             
  
                                    }
                                     }


  @override
  void initState() {
    super.initState();
    _NewsController.text = widget.news ?? "";
    _News_Link_Controller.text = widget.link ?? "";
  }

  @override
  void dispose() {
    _NewsController.dispose();
    _News_Link_Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final mediaProvider = Provider.of<MediaProvider>(context);


    return Scaffold(
      appBar: AppBar(
        title:  Text(
                  isEditMode ? "Update Media" : "Add Media", ),
                  centerTitle: true,
                  
                  ),
                  
      body: SingleChildScrollView(
        child: Column(
          children: [
         

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // News Field
                    TextFormField(
                      controller: _NewsController,
                      decoration: const InputDecoration(
                        labelText: "News",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Fill the field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Link Field
                    TextFormField(
                      controller: _News_Link_Controller,
                      decoration: const InputDecoration(
                        labelText: "Link",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Fill the field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Submit Button with Circular Indicator
                    SizedBox(
                      width: double.infinity,
                      child: 
                           ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mediaProvider.isLoading
                                  ? Colors.grey
                                  : colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: mediaProvider.isLoading
                                ? null
                                :submitMedia,
                            child: mediaProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Submit",
                                    style: textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                          )
                       
                    ),

                    const SizedBox(height: 10),

                 
                    if (!isEditMode)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CurrentNewsUploaded()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "View all News",
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
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
