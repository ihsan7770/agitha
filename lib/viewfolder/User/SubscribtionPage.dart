import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/SubscribtionController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/SubscribtionModel.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:agitha/viewfolder/Widgets/Drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscribtionPage extends StatefulWidget {
  const SubscribtionPage({super.key});

  @override
  State<SubscribtionPage> createState() => _SubscribtionPageState();
}

class _SubscribtionPageState extends State<SubscribtionPage> {
  final TextEditingController _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();





@override
Widget build(BuildContext context) {
   final subscriptionProvider =
            Provider.of<SubscriptionController>(context);
  
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

 void showSubscriptionSnackBar(BuildContext context) {
   ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Subscription Successfull"),
                 
                ),
              );
 


 
}

  return Scaffold(
    body: Column(
      children: [

           Padding(
             padding: const EdgeInsets.only(left: 16.0,right: 8.0,top: 8.0,bottom: 8.0),
             child: Align(
              alignment: Alignment.topLeft,
               child: Text(
                "Join our mailing list for updates",
                style: GoogleFonts.tinos(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
                         ),
             ),
           ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
               padding: const EdgeInsets.only(left: 16.0,right: 8.0,top: 8.0,bottom: 8.0),
               child: Text(
                "Get news & other events",
                style: GoogleFonts.tinos(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                         ),
                         ),
            ),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Enter your email",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value!.isEmpty ? "Enter your email" : null,
                          ),
                ),
              ),



                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left:16.0,right: 16.0),
                            child: ElevatedButton(
                        onPressed: () async {
  if (_formKey.currentState!.validate()) {
    bool loggedIn = await Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).checkLogin(context);

    if (loggedIn) {
      final profileService =
          Provider.of<UserRegistrationProvider>(context, listen: false);

      bool exists = await profileService.checkUserProfileExists();

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete profile for subscription')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileFormPage()),
        );
      } else {
        
         String email = _emailController.text.trim();
        final subscriptionProvider =
            Provider.of<SubscriptionController>(context, listen: false);
             Subscription subscription = Subscription(
                      documentId: '',
                      userId:'',
                      username: '',
                          
                      email: email,
                    );
        
      
                        await subscriptionProvider.addSubscription(subscription);
        
     
         
              _emailController.clear();
                showSubscriptionSnackBar(context);

      }
    }
  }
},
                                 style: ElevatedButton.styleFrom(
                              
                              backgroundColor:subscriptionProvider.isLoading ?Colors.grey[100]: colorScheme.primary ,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:subscriptionProvider.isLoading ?  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ): Text("Subscribe",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: Colors.white))
                                   




                                                  ),
                          ),
                        ),
                                 ],),
     );
  }
}