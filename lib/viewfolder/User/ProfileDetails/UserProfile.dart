import 'package:agitha/ControllersFolder/AddressController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/AddressModel.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/BookedEventDetailsFolder/UserEventTabBar.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/AddAddressPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/OrderStatusPage.dart';

import 'package:agitha/viewfolder/User/MyOrdersFolder/PendingOrderFoodDeratils.dart';



import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';

import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/UserResrvationDetailsTapBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
 
    double boxSize = screenWidth * 0.6;

    final colorScheme = Theme.of(context).colorScheme;
     final ProfileProvider = Provider.of<UserRegistrationProvider>(context, listen: false);
       final selectedAddress = Provider.of<AddressProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back,),onPressed: () {
         
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UserMainPage()),
          
          
          );
        },),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: ProfileProvider.currentUserProfileStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
        return const CircularProgressIndicator();
            }
        
            final userData = snapshot.data!;
        
           return
        Column(
          children: [
            // Profile section
            
               Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
          radius: screenWidth * 0.14,
          backgroundColor: Colors.grey.shade300,
        
          // ✅ foregroundImage handles null safely
          foregroundImage: (userData['profileImageUrl'] != null &&
            userData['profileImageUrl'].isNotEmpty)
        ? NetworkImage(userData['profileImageUrl'])
        : null,
        
          child: (userData['profileImageUrl'] == null ||
            userData['profileImageUrl'].isEmpty)
        ? Icon(
            Icons.person,
            size: screenWidth * 0.14,
            color: Colors.grey,
          )
        : null,
        ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
        
                         LayoutBuilder(
            builder: (context, constraints) {
              double nameFontSize =
                  MediaQuery.of(context).size.width * 0.05; // base scaling
              nameFontSize = nameFontSize.clamp(16.0, 24.0);
              return Text(
               " ${userData['username'] ?? ''}",
                style: GoogleFonts.tinos(
                  fontSize: nameFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              );
            },
          ),
        
        
        
                          LayoutBuilder(
            builder: (context, constraints) {
              double phoneFontSize =
                  MediaQuery.of(context).size.width * 0.04; // base scaling
              phoneFontSize = phoneFontSize.clamp(14.0, 20.0);
              return Text(
                " ${userData['phonenumber'] ?? ''}",
                style: GoogleFonts.tinos(
                  fontSize: phoneFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              );
            },
          ),

//           Text(
//   " ${userData['email'] ?? ''}",
//   maxLines: 2,
//   overflow: TextOverflow.ellipsis,
//   style: GoogleFonts.tinos(
//     fontSize:screenWidth * 0.05 ,
//     fontWeight: FontWeight.bold,
//     color: Colors.grey,
//   ),
// ),

                   LayoutBuilder(
                     builder: (context, constraints) {
                           double responsiveFontSize = MediaQuery.of(context).size.width * 0.03;
                           
                           responsiveFontSize = responsiveFontSize.clamp(12.0, 18.0);
                           
                           return Text(
                     " ${userData['email'] ?? ''}",
                     maxLines: 2,
                     overflow: TextOverflow.ellipsis,
                     style: GoogleFonts.tinos(
                       fontSize: responsiveFontSize,
                       fontWeight: FontWeight.bold,
                       color: Colors.grey,
                     ),
                   );
                   
                     },
                   ),
        
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileFormPage( 
                            username:userData['username'] ,
                            phonenumber:userData['phonenumber'] ,
                            gender:userData['gender'] ,
                            dob: userData['dob'],
                            imageurl:userData['profileImageUrl'],
                            id: userData['documentid'],
        
        
                           )),
                        );
                      },
                      child: const Text("Edit"),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 30),
        // Address section
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 8.0),
            child: Text(
        "Current Address",
        style: GoogleFonts.tinos(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
            ),
          ),
        ),
        
        StreamBuilder<AddressModel?>(
          stream: context.read<AddressProvider>().selectedAddressStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.only(left: 20),
          child: SizedBox.shrink(),
        );
            }
        
            if (!snapshot.hasData || snapshot.data == null) {
        return Padding(
  padding: const EdgeInsets.only(left: 20, right: 20),
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.grey.shade100, // light grey background
      border: Border.all(
        color: Colors.grey, // grey outline
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text(
      "No address selected",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey, // grey text
        fontSize: 14,
      ),
    ),
  ),
);
            }
        
            final selectedAddress = snapshot.data!;
        
            return Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                selectedAddress.housename,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10),
              child: Text(
                selectedAddress.address,
                textAlign: TextAlign.start,
                style: GoogleFonts.tinos(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 123, 122, 122),
                ),
              ),
            ),
          ],
        ),
            );
          },
        ),
        
        
            // ListTile buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.receipt_long,
                    color: colorScheme.primary, size: 30), // bigger + primary
                title: Text(
                  "My Orders",
                  style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  PendingOrderfoodPage()));
                },
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.location_on,
                    color: colorScheme.primary, size: 30),
                title: Text(
                  "Manage Address",
                  style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddAddressPage()),
                  );
                },
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.event,
                    color: colorScheme.primary, size: 30),
                title: Text(
                  "My Reservations",
                  style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const  MyReservationTabBarPage ()));
                },
              ),
            ),
        
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.celebration_rounded,
                    color: colorScheme.primary, size: 30),
                title: Text(
                  "My Event Bookings",
                  style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const   UserEventTabBar ()));
                },
              ),
            ),

        
      //       ElevatedButton(
      // onPressed: () { 

      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage()),);
      // },
      // style: ElevatedButton.styleFrom(
      // backgroundColor:
      // Theme.of(context).colorScheme.primary,
      // foregroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      // borderRadius: BorderRadius.circular(20),
      // ),
      // ),
      //    child: const Text("Delete"),
      //  ),
        
        
        
          ],
        
        
        
        );}),
      )
    );
  }
}
