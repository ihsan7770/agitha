import 'dart:async';

import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/DeliveryBoy/ApproveDeliveryBoy.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyInstructionUser.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyMainPage.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyInstruction.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyMainPage.dart';
import 'package:agitha/viewfolder/SubCompany/RestuarantApprovalpage.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final String email;
  final String phone;
  final String role;
  final String password;

  const OtpPage({
    super.key,
    required this.email,
    required this.phone,
    required this.role,
    required this.password
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

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

Future<void> verifyOTP() async {
  // ✅ Validate form
  if (!_formKey.currentState!.validate()) return;

  // ✅ Providers (listen: false is REQUIRED in async methods)
  final auth =
      Provider.of<AuthenticationController>(context, listen: false);
  final companyProvider =
      Provider.of<RestaurantViewProvider>(context, listen: false);
  final deliveryboyProvider =
      Provider.of<DeliveryBoyViewProvider>(context, listen: false);

  final colorScheme = Theme.of(context).colorScheme;

  // ✅ OTP verification + signup
  final result = await auth.verifyOtpAndSignUpUser(
    otp: _otpController.text.trim(),
    email: widget.email,
    password: widget.password,
    phone: widget.phone,
    role: widget.role,
  );

  if (!mounted) return;

  // ❌ If failed
  if (result != "success") {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
    );
    return;
  }

  // ✅ ROLE BASED NAVIGATION
  switch (widget.role) {
    case "User":
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserMainPage()),
      );
      break;

    case "Delivery Boy":
      final isRegistered = await auth.isDeliveryBoyRegistered();
      final isApproved =
          await deliveryboyProvider.isDeliveryBoyApproved();

      if (!isRegistered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DeliveryBoyInstructionsUser(),
          ),
        );
      } else if (!isApproved) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ApproveDeliveryBoy(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DeliveryBoyMainPage(),
          ),
        );
      }
      break;

    case "Company":
      final isRegistered = await auth.isCompanyRegistered();
      final isApproved =
          await companyProvider.isRestaurantApproved();

      if (!isRegistered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CompanyInstrutions(),
          ),
        );
      } else if (!isApproved) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const RestaurantRegistrationStatus(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CompanyMainPage(),
          ),
        );
      }
      break;

    default:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unknown role: ${widget.role}"),
          backgroundColor: colorScheme.error,
        ),
      );
  }
}



  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthenticationController>();
      final size = MediaQuery.of(context).size;
      final height = size.height;
      final width = size.width;

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
            color: Theme.of(context).colorScheme.primary,
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back,
                    size: 30, color: Colors.white),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.06,
          vertical: height * 0.03,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              SizedBox(height: height * 0.05),

              Icon(
                Icons.lock_outline,
                size: width * 0.22,
                color: Theme.of(context).colorScheme.primary,
              ),

              SizedBox(height: height * 0.03),

              Text(
                "Enter the OTP sent to",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: width * 0.04,
                ),
              ),

              SizedBox(height: height * 0.01),

              Text(
                widget.phone,
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.04),

              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: width * 0.02,
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return "Enter valid 6-digit OTP";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "------",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive OTP? ",
                    style: TextStyle(fontSize: width * 0.035),
                  ),
                  InkWell(
                    onTap: _isButtonEnabled
                        ? () async {
                            _startTimer();
                            await AuthenticationController()
                                .resendOTP(widget.phone);
                          }
                        : null,
                    child: Text(
                      _isButtonEnabled
                          ? "Resend"
                          : "Resend in $_secondsRemaining",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: _isButtonEnabled
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.03),

              SizedBox(
                width: double.infinity,
                height: height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(width * 0.03),
                    ),
                  ),
                  onPressed: auth.isLoading ? null : verifyOTP,
                  child: auth.isLoading
                      ? SizedBox(
                          width: width * 0.05,
                          height: width * 0.05,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Verify OTP",
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        ),
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
