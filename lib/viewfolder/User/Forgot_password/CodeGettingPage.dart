import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/User/Forgot_password/ResetPassword.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeGettingPage extends StatefulWidget {
  const CodeGettingPage({super.key});

  @override
  State<CodeGettingPage> createState() => _CodeGettingPageState();
}

class _CodeGettingPageState extends State<CodeGettingPage> {
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
              "Get Your Code",
              style: GoogleFonts.tinos(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
            ),

            const SizedBox(height: 20,),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please enter the 4 digit code that send to your email address",
              style: TextStyle(color: Colors.grey,fontSize: 16),
               textAlign: TextAlign.center,
              ),
            ),


            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: List.generate(4, (index) {
                    return  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 50,
                        child: TextFormField(
                        
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                        
                        counterText: "",
                        border:const  OutlineInputBorder(),


                          ),
                          onChanged: (value){
                            if(value.isNotEmpty && index<3){
                              FocusScope.of(context).nextFocus();
                            }
                            else if (value.isEmpty){
                               FocusScope.of(context).previousFocus();
                            }
                          },




                            validator: (value) =>
                                    value!.isEmpty ? "0" : null,
                          
                        
                        ),
                      ),
                    );
                
                
                
                  }),),
              ),
            ),

             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text("If you don't receive code! ",style: TextStyle(color: Colors.grey,fontSize: 14),),
              InkWell(
                onTap: () {
                  
                },
                child: Text("Resend" ,style:TextStyle(color: colorScheme.primary,fontSize: 14,fontWeight: FontWeight.bold)))
              
              ],),

            
                  




                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 20,bottom: 0),
                            child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                              backgroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                              
                              
                              
                             
                            onPressed: () {
                                 if (_formKey.currentState!.validate()) {
                                Navigator.push(context, MaterialPageRoute(builder:(context)=> const ResetPasswordPage()));
                                 }
                                                     
                            },
                            child: Text("Verify and Proceed",
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