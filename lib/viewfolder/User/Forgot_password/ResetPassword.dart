import 'package:agitha/ControllersFolder/ForgetPasswordController.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgotPasswordProvider>(context);

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
            color:Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                 Text(
                  "Set New Password",
                style: GoogleFonts.tinos(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
                ),
                const SizedBox(height: 30),
        
                /// 🔑 New Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
        
                /// 🔑 Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
        
                const SizedBox(height: 30),
        
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                     shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    
                    
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white
                    ),
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final result =
                                  await provider.updatePasswordOnly(
                                password: _passwordController.text.trim(),
                              );
        
                              if (result == "success") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Password updated successfully")),
                                );
        
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result)),
                                );
                              }
                            }
                          },
                    child: provider.isLoading
                        ? 
const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )




                        : const Text("Update Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
