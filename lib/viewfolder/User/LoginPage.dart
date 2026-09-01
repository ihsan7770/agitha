import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/viewfolder/Admin/AdminHomePage.dart';
import 'package:agitha/CustomShapeClass.dart';
import 'package:agitha/viewfolder/DeliveryBoy/ApproveDeliveryBoy.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyHomePage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyInstructionUser.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyMainPage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyRegistration.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/SignupFolder/SignUpPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyInstruction.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyMainPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyResgistration.dart';
import 'package:agitha/viewfolder/SubCompany/RestuarantApprovalpage.dart';
import 'package:agitha/viewfolder/User/Forgot_password/ForgotPasswordFirst.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String adminName ="admin@gmail.com";
  String password = "123456";


 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 
  String? _selectedRole;
  // final List<String> _roles = ["User", "Delivery Boy", "Company",];


  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationController>(context);
    final companyProvider=Provider.of<RestaurantViewProvider>(context);
    final deliveryboyProvider=Provider.of<DeliveryBoyViewProvider>(context);
    
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;


 Future<void> loginSubmit() async {
  if (_formKey.currentState!.validate()) {

    String role = await authProvider.login(

      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if(_emailController.text ==adminName && _passwordController.text==password){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHomePage()),
      );

    }


    else if (role == "User") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserMainPage()),
      );


//check DeliveryBoyregistered or not
    } else if (role == "Delivery Boy") {
        bool isdbRegistered = await authProvider.isDeliveryBoyRegistered();
          bool isDeliveryboyApproved = await deliveryboyProvider.isDeliveryBoyApproved();
       

         if (!isdbRegistered) {
    // DeliveryBoynot registered → go to registration instructions page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DeliveryBoyInstructionsUser()),
    );
  } else if (!isDeliveryboyApproved) {
    // DeliveryBoy registered but not approved → go to registration status page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ApproveDeliveryBoy( )),
    );
  } else {
    // DeliveryBoy registered and approved → go to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DeliveryBoyMainPage()),
    );
  }
}




// 

    
else if (role == "Company") {
  bool isRegistered = await authProvider.isCompanyRegistered();
  bool isCompanyApproved = await companyProvider.isRestaurantApproved();

  if (!isRegistered) {
    // Company not registered → go to registration instructions page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CompanyInstrutions()),
    );
  } else if (!isCompanyApproved) {
    // Company registered but not approved → go to registration status page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RestaurantRegistrationStatus( )),
    );
  } else {
    // Company registered and approved → go to home page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CompanyMainPage()),
    );
  }
}
 else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(role),
          backgroundColor: colorScheme.primary,
        ),
      );
    }



  }
}


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
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                        onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder:(context)=> const UserMainPage()));
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
            "Login",
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
                   
                      // DropdownButtonFormField<String>(
                      //   value: _selectedRole,
                      //   decoration: const InputDecoration(
                      //     labelText: "Select Role",
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   items: _roles
                      //       .map((role) => DropdownMenuItem(
                      //             value: role,
                      //             child: Text(role),
                      //           ))
                      //       .toList(),
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _selectedRole = value;
                      //     });
                      //   },

                      //     validator: (value) {
                      //    String email = _emailController.text.trim();
                        
                      //     // ✅ If email is admin email → no error even if role not selected
                      //     if (email == adminName) {
                      //       return null;
                      //     }
                        
                      //     // ✅ For normal users → role required
                      //     if (value == null || value.isEmpty) {
                      //       return "Please select a role";
                      //     }
                        
                      //     return null;
                      //   },


                      // ),
                      const SizedBox(height: 16),

                     
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
                      const SizedBox(height: 24),

                    
                      ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                              loginSubmit();
                                
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
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Login",
                                style: textTheme.bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                      ),


                      const SizedBox(height: 12),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                               Navigator.push(
                               context,
                                 MaterialPageRoute(builder: (context) => const ForgotPasswordFirstPage ()),
                             );
                          },
                          child: const Text("Forgot Password?"),
                        ),
                      ),

                      const SizedBox(height: 80),
                      // Sign Up option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don’t have an account? "),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
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
