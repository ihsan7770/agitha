import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/ModelsFoder/SignUpmodel.dart';

import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/SignupFolder/OtpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController();

  // Dropdown value
  String? _selectedRole;
  final List<String> _roles = ["User", "Delivery Boy", "Company"];

  // Password visibility
  bool _obscurePassword = true;


Future<void> SignUpSubmit() async {
  final authProvider =
      Provider.of<AuthenticationController>(context, listen: false);

  // final phone = "+91${_phoneNumberController.text.trim()}"; use for real numbers

   final phone = "+1${_phoneNumberController.text.trim()}";

  if (_formKey.currentState!.validate()) {
    final result = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: phone,
      
    );

    debugPrint("📌 Signup result: $result");

  
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(
            password: _passwordController.text.trim(),
            email: _emailController.text.trim(),
            phone: phone,
            role: _selectedRole ?? "user",
          ),
        ),
      );
  
    
  }

  
}


  @override
  Widget build(BuildContext context) {
    final authProvider =Provider.of<AuthenticationController>(context);
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
                           Navigator.push(context, MaterialPageRoute(builder:(context)=> const LoginPage()));
                        },
                        icon: const Icon(Icons.arrow_back,size: 30,color: Colors.white,),),
              ),
            ), 
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
             Text(
            "Sign Up",
            style: GoogleFonts.tinos(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 75, 2, 2),
            ),
          ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: "Select Role",
                          border: OutlineInputBorder(),
                        ),
                        items: _roles
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Please select a role" : null,
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.isEmpty || !value.contains('@')
                      ? "Enter a valid email"
                      : null,
                      ),
                      const SizedBox(height: 16),

                        TextFormField(
                       controller: _phoneNumberController,
                       decoration: const InputDecoration(
                         labelText: "Phone Number",
                         border: OutlineInputBorder(),
                       ),
                       keyboardType: TextInputType.number,
                      //  maxLength: 10, // optional: limits input to 10 digits
                       validator: (value) {
                         if (value == null || value.isEmpty) {
                           return "Phone number is required";
                         } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                           return "Enter a valid 10-digit number";
                         }
                         return null;
                       },
                  ),

                       const SizedBox(height: 16),

                      // Password field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
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
                    



                      const SizedBox(height: 24),

   ElevatedButton(
    onPressed: authProvider.isLoading
        ? null // Disable button while loading
        : ()  {
          SignUpSubmit();
          
        },
  style: ElevatedButton.styleFrom(
    backgroundColor: colorScheme.primary,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: authProvider.isLoading
      ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : Text(
          "Sign Up",
          style: textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
         ),


                      const SizedBox(height: 100),

                   
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
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
