import 'dart:async';

import 'package:agitha/ControllersFolder/ForgetPasswordController.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/User/Forgot_password/ResetPassword.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   int _secondsRemaining = 30;
  Timer? _timer;
  bool _isButtonEnabled = false;




    @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _isButtonEnabled = false;
    _secondsRemaining = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _isButtonEnabled = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }



  @override
  void dispose() {
    _otpController.dispose();
      _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgotPasswordProvider>(context);

    return Scaffold(
      appBar:
      
       AppBar(
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
          child: Column(
            children: [
              Text(
                "Enter OTP",
                 style: GoogleFonts.tinos(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
              ),
              const SizedBox(height: 10),
              Text(
                "OTP sent to ${widget.phoneNumber}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
        
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                 
                  decoration: const InputDecoration(
                    labelText: "OTP",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length != 6) {
                      return "Enter valid 6-digit OTP";
                    }
                    return null;
                  },
                ),
              ),


                       Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text("Didn't receive OTP? "),
                   InkWell(
                     onTap: _isButtonEnabled
                         ? ()async {
                             // 🔁 Resend logic here
                             _startTimer();
                              await ForgotPasswordProvider().resendOTP(widget.phoneNumber);
                           }
                         : null,
                     child: Text(
                       _isButtonEnabled
                           ? "Resend"
                           : "Resend in $_secondsRemaining",
                       style: TextStyle(
                         color: _isButtonEnabled
                             ? Theme.of(context).colorScheme.primary
                             : Colors.grey,
                         fontWeight: FontWeight.w400,
                       ),
                     ),
                   ),
                 ],
               ),
         ),
        
              const SizedBox(height: 10),
        
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
                            final result = await provider.verifyOtp(
                              otp: _otpController.text.trim(),
                            );
        
                            if (result == "success") {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordPage()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("OTP Verified")),
                              );
                              // 👉 Navigate to Reset Password Page
                            } else {
                             
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result)),
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
                      : const Text("Verify OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
