import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/User/Forgot_password/CodeGettingPage.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordFirstPage extends StatefulWidget {
  const ForgotPasswordFirstPage({super.key});

  @override
  State<ForgotPasswordFirstPage> createState() => _ForgotPasswordFirstPageState();
}

class _ForgotPasswordFirstPageState extends State<ForgotPasswordFirstPage> {

  
    final TextEditingController _emailController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
    return Scaffold(

    appBar:  AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 130,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            color: colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back,size: 30,color: Colors.white,),),
              ),
            ),
         ),
        ),
      ),
      body: Center(
        child: Column(
         
          children: [
        
            Text(
              "Forgot Password",
              style: GoogleFonts.tinos(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
            ),

            const SizedBox(height: 20,),

            const Text("Enter the email address associated with your account",
            style: TextStyle(color: Colors.grey,fontSize: 16),
             textAlign: TextAlign.center,
            ),

            
                      
                      Form(
                        key: _formKey,

                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
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
                            padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 0,bottom: 0),
                            child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                              
                              
                              
                             
                            onPressed: () {
                               if (_formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder:(context)=> const CodeGettingPage()));
                            }
                            
                             
                                                     
                            },
                            child:  Text("Recover Password",
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white)),
                                                  ),
                                                      ),
                          ),
          ],
        
        
        
        
        ),
      ),


    );
  }
}


