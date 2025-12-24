import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/ModelsFoder/SignUpmodel.dart';

import 'package:agitha/viewfolder/User/LoginPage.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Dropdown value
  String? _selectedRole;
  final List<String> _roles = ["User", "Delivery Boy", "Company"];

  // Password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

 Future<void> SignUpSubmit() async {
    final authProvider =Provider.of<AuthenticationController>(context,listen: false);
    final colorScheme = Theme.of(context).colorScheme;
if (_formKey.currentState!.validate()) {
            final result = await authProvider.signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              role: _selectedRole ?? "",
            );

            if (result == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: const Text("Successfully Signed In"),
                  backgroundColor: Colors.red[900],
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result),
                  backgroundColor: colorScheme.primary
                ),
              );
            }
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
