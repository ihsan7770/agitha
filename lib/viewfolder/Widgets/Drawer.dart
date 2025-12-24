import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/check.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationDetailsPage.dart';
import 'package:agitha/viewfolder/User/AboutUsPage.dart';
import 'package:agitha/viewfolder/User/ContactUsPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
// import 'package:agitha/User/FoodOrderingFolder/MyOrdersFolder/OrderedFoodDetails.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/UserProfile.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/PendingReservationUserPage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/UserSettings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserRegistrationProvider>(context);

    final name = userInfo.name .toString();
    final email = userInfo.email .toString();
    final colorScheme = Theme.of(context).colorScheme;
    bool  isloggedin= Provider.of<AuthenticationController>(context, listen: false).isLoggedIn;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          isloggedin?
          
           UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primary  ,
            ),
            accountName:   Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail:  Text(email),
            currentAccountPicture: const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.redAccent),
            ),
           
           
                     )


         : Container(
            color: colorScheme.primary,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Column(
              children: [
               
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(
                      "Guest User",
                      style:  GoogleFonts.tinos(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0),
                  child: Text(
                    'You are currently a guest user. To access any services, please log in',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> const LoginPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                                  ),
                                  child: const Text(
                    "Login / Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                  ),
                ),
              ],
            ),
          ),



           
          // Profile
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black87),
            title: const Text('Profile'),
            onTap: () async {
  final authController = Provider.of<AuthenticationController>(context, listen: false);
  final profileProvider = Provider.of<UserRegistrationProvider>(context, listen: false);

  bool loggedIn = authController.checkLogin(context);
   

  if (!loggedIn) {
    // ✅ Not logged in → Go to Login alert
   Provider.of<AuthenticationController>(context, listen: false).checkLogin(context);
    return;
  }

  // ✅ User logged in → Check profile exists in Firestore
  bool isProfileCreated = await profileProvider.checkUserProfileExists();

  if (!isProfileCreated) {
    // ✅ No profile → Go to Create Profile page
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileFormPage()));
  } else {
    // ✅ Profile exists → Go to Profile page
    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()));
  }
},

          ),

          // const SizedBox(height: 10,),

         

          // About Us
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.black87),
            title: const Text('About Us'),
            onTap: () {

               Navigator.push(context, MaterialPageRoute(builder:(context)=> const AboutUsPage()));
              
            

            },
          ),





      

          // Contact Us
          ListTile(
            leading: const Icon(Icons.support_agent, color: Colors.black87),
            title: const Text('Contact Us'),
            onTap: () {

            
             Navigator.push(context, MaterialPageRoute(builder:(context)=> const ContactUsPage()));
            },
          ),
                ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.black87),
            title: const Text('My Cart'),
              onTap: () async {
    // 1️⃣ Check login
    bool loggedIn = await Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).checkLogin(context);

    if (loggedIn) {
      // 2️⃣ Check if profile exists
      final profileService =
          Provider.of<UserRegistrationProvider>(context, listen: false);

      bool exists = await profileService.checkUserProfileExists();

      if (!exists) {
        // Navigate to Profile Form Page
    Navigator.pop(context); // Close bottom sheet safely
     Future.microtask(() {
       Navigator.push(
         context,
         MaterialPageRoute(builder: (_) => const ProfileFormPage()),
       );
});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete profile for rating')),
        );

        return; // ❗ Stop further execution
      }
    

               Navigator.push(context, MaterialPageRoute(builder:(context)=> const FoodCartPage()));
              
    }

            },
          ),

                 ListTile(
            leading: const Icon(Icons.settings, color: Colors.black87),
            title: const Text('Settings'),
            onTap: () {

               Navigator.push(context, MaterialPageRoute(builder:(context)=> const UserSettings()));
              


            },
          ),

           ListTile(
            
                       leading: Icon(Icons.logout, color:Colors.red,),
                       
                       title: Text('Logout', style: TextStyle(
              
               
                color:Colors.red
                            ),),
                       onTap: () async {
           
            AuthenticationController().logout(context);
            final cartController = Provider.of<CartController>(context, listen: false);
            await cartController.clearCartOnLogout();

            
           
           
                       },
                     ),





        ],
      ),
    );
  }
}
