import 'package:agitha/ControllersFolder/AdminHomeController.dart';
import 'package:agitha/viewfolder/Admin/AboutFolder/AdminAboutMainpage.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedAccountsTabBar.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedUsers.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/JobApplications.dart';
import 'package:agitha/viewfolder/Admin/ContactMessages.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/ViewDeliveyBoys.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/Addinstructions.dart';
import 'package:agitha/viewfolder/Admin/RestorentFolder/ViewRestorents.dart';
import 'package:agitha/viewfolder/Admin/SubscribtionDetails.dart';
import 'package:agitha/viewfolder/Admin/UserDetails.dart';
import 'package:agitha/viewfolder/Admin/MediaFolder/Mediafromfeild.dart';
import 'package:agitha/viewfolder/Admin/ViewRatingsAndReview.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;
final double w = size.width;
final double h = size.height;
      final provider = Provider.of<DashboardStreamProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      
      drawer: Drawer(
      
      child:
       Column(
         children: [
                Container(
        height: 180,
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:Image.asset('assets/agithaicon.png',width: 200,height: 200,color:Colors.black),
        ),
      ),

          Expanded(
             child: ListView(
              children: [
              
               
                  
                  //Users
                  ListTile(
                  leading: const Icon(Icons.people_alt, color: Colors.black87),
                  title: const Text('Users'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> const AdminSideUserDetails()));
                  },
                ),
             
                   //About
                   ListTile(
                  leading: const Icon(Icons.info, color: Colors.black87),
                  title: const Text('About'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> const AdminAboutMainPage()));
                  },
                ),
             
                    //Media
                   ListTile(
                  leading: const Icon(Icons.photo, color: Colors.black87),
                  title: const Text('Media'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> const MediaFormField( )));
                  },
                ),

                  ListTile(
                  leading: const Icon(Icons.article, color: Colors.black87),
                  title: const Text('Manage Instructions'),
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> const AddInstructions(
                   
                  )));
                  },
                ),
             
             
                  //Manage Restaurants
                   ListTile(
                  leading: const Icon(Icons.restaurant, color: Colors.black87),
                  title: const Text('Manage Restaurants'),
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> const ViewRestorents()));
                  },
                ),
             
                  //Manage Delivery Boy
                        ListTile(
                  leading: const Icon(Icons.delivery_dining, color: Colors.black87),
                  title: const Text('Manage Delivery Boy'),
                  onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=> const ViewDeliveryBoys ()));
                  },
                ),
             
             
             
                 //Subscribtion
                 ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.black87),
                  title: const Text('Subscriptions'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> const SubscribtionDetails()));
                  },
                ),


                    //Subscribtion
                 ListTile(
                  leading: const Icon(Icons.reviews, color: Colors.black87),
                  title: const Text('Ratings & Reviews'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> ReviewsPage()));
                  },
                ),

                    //Subscribtion
                 ListTile(
                  leading: const Icon(Icons.block, color: Colors.black87),
                  title: const Text('Blocked Accounts'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> const BlockedAccountTabBar()));
                  },
                ),
             
             
             
                 
                 //Contact us
                 ListTile(
                  leading: const Icon(Icons.support_agent, color: Colors.black87),
                  title: const Text('Contact us'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> const ContactMessages()));
                  },
                ),
             
                  //Careers
                 ListTile(
                  leading: const Icon(Icons.work, color: Colors.black87),
                  title: const Text('Careers'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> const JobApplications()));
                  },
                ),
             
               
         ],
                       ),
           ),
         ],
       ),),           
        // Drower ends

        body:SingleChildScrollView(
          child: Column(
            children: [
          
              /// 🔹 TOP IMAGE
              Container(
                height: h * 0.23, // was 180
                width: double.infinity,
                padding: EdgeInsets.all(w * 0.04), // was 12
                decoration: const BoxDecoration(
          color: Colors.white,
                ),
                child: ClipRRect(
          borderRadius: BorderRadius.circular(w * 0.04), // was 12
          child: Image.asset(
            'assets/agithaicon.png',
            color: Colors.black,
          ),
                ),
              ),
          
              SizedBox(height: h * 0.04), // was 30
          
              /// 🔹 RESTAURANT + USERS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
          
          Column(
            children: [
              Text(
                "Total Restaurants",
                style: GoogleFonts.tinos(
                  fontSize: w * 0.06, // was 25
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                provider.companyCount.toString(),
                style: GoogleFonts.tinos(
                  fontSize: w * 0.07, // was 30
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          
          SizedBox(width: w * 0.05), // was 20
          
          Column(
            children: [
              Text(
                "Total Users",
                style: GoogleFonts.tinos(
                  fontSize: w * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                provider.userProfileCount.toString(),
                style: GoogleFonts.tinos(
                  fontSize: w * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
                ],
              ),
          
              SizedBox(height: h * 0.04), // was 30
          
              /// 🔹 DELIVERY BOYS
              Column(
                children: [
          Text(
            "Total Delivery Boys",
            style: GoogleFonts.tinos(
              fontSize: w * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            provider.deliveryBoyCount.toString(),
            style: GoogleFonts.tinos(
              fontSize: w * 0.07,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
                ],
              ),
          
              SizedBox(height: h * 0.12), // was 100
          
              /// 🔹 LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.14, // was 56
          ),
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: colorScheme.primary,
              padding: EdgeInsets.symmetric(
                vertical: h * 0.018,
              ),
            ),
            icon: Icon(
              Icons.arrow_back,
              size: w * 0.05, // was 20
            ),
            label: Text(
              "Logout",
              style: GoogleFonts.tinos(
                fontSize: w * 0.05, // was 20
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserMainPage(),
                ),
              );
            },
          ),
                ),
              ),
            ],
          ),
        )
             
   

     

       














    );
  }
}