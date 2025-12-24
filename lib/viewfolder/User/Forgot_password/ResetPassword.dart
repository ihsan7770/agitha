import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
   final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _confirmPasswordController =  TextEditingController();
   bool _obscurePassword = true;
   bool _obscureConfirmPassword = true;
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
              "Enter New Password",
              style: GoogleFonts.tinos(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
            ),

            const SizedBox(height: 20,),

            const Text("Your new password must be different from previously used password",
            style: TextStyle(color: Colors.grey,fontSize: 16),
             textAlign: TextAlign.center,
            ),

              
                      Form(
                        key:_formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? "Enter your password" : null,
                              ),
                              const SizedBox(height: 16),
                              
                              // Confirm Password field
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Confirm your password";
                                  } else if (value != _passwordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

            
                    

                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                            padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 10,bottom: 0),
                            child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                             
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                              
                              
                              
                             
                            onPressed: () {
                            
                                if (_formKey.currentState!.validate()) {
                                Navigator.push(context, MaterialPageRoute(builder:(context)=> const LoginPage()));
                                 }
                            
                                                     
                            },
                            child: Text("Continue",
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