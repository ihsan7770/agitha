import 'package:agitha/ControllersFolder/ForgetPasswordController.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/Forgot_password/OtpCodeGettingPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotPasswordFirstPage extends StatefulWidget {
  const ForgotPasswordFirstPage({super.key});

  @override
  State<ForgotPasswordFirstPage> createState() =>
      _ForgotPasswordFirstPageState();
}

class _ForgotPasswordFirstPageState extends State<ForgotPasswordFirstPage> {
  final TextEditingController _emailOrPhoneController= TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPhone(String value) {
  return RegExp(r'^[0-9]{10}$').hasMatch(value);
}

bool isEmail(String value) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
}


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
      final height = size.height;
      final width = size.width;

    final provider = Provider.of<ForgotPasswordProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
                  icon: const Icon(Icons.arrow_back,
                      size: 30, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
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
              const SizedBox(height: 20),
               Text(
                "Enter the Phone number associated with your account",
                style: TextStyle(color: Colors.grey, fontSize: width * 0.05),
                textAlign: TextAlign.center,
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
        
                  child: TextFormField(
          controller: _emailOrPhoneController,
          decoration: const InputDecoration(
            labelText: "Email or Phone Number",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        
          validator: (value) {
            debugPrint("📩 Email/Phone input: $value");
        
            if (value == null || value.trim().isEmpty) {
        return "Enter email or phone number";
            }
        
            final emailRegex =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            final phoneRegex =
          RegExp(r'^[0-9]{10}$');
        
            if (emailRegex.hasMatch(value.trim()) ||
          phoneRegex.hasMatch(value.trim())) {
        return null; // ✅ valid email OR phone
            }
        
            return "Enter a valid email or 10-digit phone number";
          },
        ),
        
        
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  onPressed: provider.isLoading
            ? null
            : () async {
          if (_formKey.currentState!.validate()) {
            final input = _emailOrPhoneController.text.trim();
        
            // 📱 PHONE NUMBER → OTP
            if (isPhone(input)) {

        final phone = "+1$input"; // change country code if required
        
        final result = await provider.sendOtp(phone: phone);
        
        if (result == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpVerificationPage(phoneNumber: phone),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }
            }
        
            // 📧 EMAIL → PASSWORD RESET LINK
           else if (isEmail(input)) {
          await provider.sendPasswordResetEmail(email: input);
        
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
        return AlertDialog(
          title: const Text("Password Reset"),
          content: const Text(
            "Password reset link has been sent to your email",
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
        
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UserMainPage(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        );
            },
          );
        }
        
        
          }
        },
        
        
                    child: provider.isLoading
                        ? const 
                        SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                        : Text("Recover Password",
                            style: textTheme.bodyLarge
                                ?.copyWith(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
