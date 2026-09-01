import 'package:agitha/ControllersFolder/AboutOusController.dart';
import 'package:agitha/ModelsFoder/AboutModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AboutFormField extends StatefulWidget {
  final String title;      
  final String label;      
  // final String initialText; 

  const AboutFormField({
    super.key,
    required this.title,
    required this.label,
    // required this.initialText,
  });
  

  @override
  State<AboutFormField> createState() => _AboutFormFieldState();
}

class _AboutFormFieldState extends State<AboutFormField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();




  void submitAbout()async{
       final colorScheme = Theme.of(context).colorScheme;

      if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AboutProvider>(context, listen: false);

      // Get previous data or default empty
      final currentData = provider.aboutData ??
          AboutUsModel(
            about: "",
            ourPeople: "",
            missionAndVision: "",
            wordFromChairman: "",
          );

      // Update the specific field
      switch (widget.title) {
        case "About Us":
          currentData.about = _textController.text.trim();
          break;
        case "Our People":
          currentData.ourPeople = _textController.text.trim();
          break;
        case "Mission and Vision":
          currentData.missionAndVision = _textController.text.trim();
          break;
        case "Word from Chairman":
          currentData.wordFromChairman = _textController.text.trim();
          break;
      }

      // Save to Firestore
      await provider.updateAbout("aboutDoc", currentData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.title} updated successfully"),
        backgroundColor: colorScheme.primary,
        ),
        
      );

      Navigator.pop(context);
    }




  }



@override
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final provider = Provider.of<AboutProvider>(context, listen: false);
    provider.fetchAbout("aboutDoc").then((_) {
      final aboutData = provider.aboutData;

      if (aboutData != null && mounted) {
        setState(() {
          switch (widget.title) {
            case "About Us":
              _textController.text = aboutData.about;
              break;
            case "Our People":
              _textController.text = aboutData.ourPeople;
              break;
            case "Mission and Vision":
              _textController.text = aboutData.missionAndVision;
              break;
            case "Word from Chairman":
              _textController.text = aboutData.wordFromChairman;
              break;
          }
        });
      }
    });
  });
}


// @override
// void initState() {
//   super.initState();
//   _textController = TextEditingController(text: widget.initialText);
// }


  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aboutProvider = Provider.of<AboutProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text( widget.title) ,
        centerTitle: true,
      
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
    

           
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    alignLabelWithHint: true,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Fill the field";
                    }
                    return null;
                  },
                ),
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left:16.0,right: 16.0),
                child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor:aboutProvider.isButtonLoading
                   ? Colors.grey[100] 
                   : colorScheme.primary, 
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  onPressed: submitAbout,
  child:aboutProvider.isButtonLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
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
          ],
        ),
      ),
    );
  }
}
