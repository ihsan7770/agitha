
import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/RestourentHomeController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/FoodItemTabBar.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/CompanyViewDeliveryBoy.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyProfileFolder/CompanyProfile.dart';
import 'package:agitha/viewfolder/SubCompany/RestaurantRating_ReviewDetails.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  @override
  Widget build(BuildContext context) {
     final provider = Provider.of<RestaurantHomeProvider>(context);
     final restaurant = provider.restaurant;
    
    return  Scaffold(
      
        appBar: AppBar(),
      drawer: Drawer(child: ListView(
        padding: EdgeInsets.zero,
        children: [



StreamBuilder<CompanyRegistrationModel?>(
  stream: context.read<RestaurantHomeProvider>().restaurantStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Center(child: Text("No restaurant data found"));
    }

    final restaurant = snapshot.data!;

    return Container(
      height: 180,
      width: double.infinity,
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius:const BorderRadius.only(bottomLeft:Radius.circular(20),bottomRight: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [Colors.red.shade800, Colors.red.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ✨ Decorative faded fork & spoon icon (optional aesthetic)
          Positioned(
            right: -20,
            top: -10,
            child: Icon(
              Icons.restaurant_menu,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),

          // 🌟 Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.restaurantName,
                  style: GoogleFonts.tinos(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  restaurant.brandType,
                  style: GoogleFonts.tinos(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children:  [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      restaurant.rating.toString(),
                      style:  GoogleFonts.tinos(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
),

      


          



           
          // Profile
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black87),
            title: const Text('Profile'),
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder:(context)=> const CompanyProfile ()));
            },
          ),

          // Delivery Boy Details
          ListTile(
            leading: const Icon(Icons.delivery_dining, color: Colors.black87),
            title: const Text('Delivery Boy Details'),
            onTap: () {

            Navigator.push(
             context,
            MaterialPageRoute(
            builder: (context) => const CompanyViewDeliveryBoys(),
               ),
             );
             


             
              
            },
          ),


     

          // Add food item
          ListTile(
            leading: const Icon(Icons.event_available, color: Colors.black87),
            title: const Text('Add food item'),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder:(context)=> const AddFoodItem()));
            },
          ),


            // Add food item
          ListTile(
            leading: const Icon(Icons.fastfood_rounded, color: Colors.black87),
            title: const Text('Total Food Items'),
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder:(context)=> const FoodItemTabBar ()));
            },
          ),

          
            ListTile(
                  leading: const Icon(Icons.reviews, color: Colors.black87),
                  title: const Text('Ratings & Reviews'),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder:(context)=> RestaurantRating_ReviewPage()));
                  },
                ),


             // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black87),
            title: const Text('Logout'),
            onTap: () {
              AuthenticationController().logout(context);
            },
          ),

         
        ],
      ), 
      
       ),
        body:SingleChildScrollView(
          child: Column(children: [
          
             Padding(
               padding: const EdgeInsets.all(12.0),
               child: ClipRRect(
               borderRadius: BorderRadius.circular(20), 
               child: Image.asset(
               "assets/projectimages/2nd.jpg", 
               fit: BoxFit.cover,               
               width: double.infinity,          
               height: 300,                     
                  ),
                 ),
             ),
          
          
          
               Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0, top: 40),
                            child: Text(
                            "Total Orders",
                            style: GoogleFonts.tinos(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 75, 2, 2),
                            ),
                                            ),
                          ),
          
                            Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0, top: 6),
                            child: Text(
                            "23",
                            style: GoogleFonts.tinos(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 80, 79, 79)
                            ),
                                            ),
                          ),
          
          
          
          
          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                    padding: const EdgeInsets.only(left:16.0,right:16.0, top: 10),
                                    child: Text(
                                    "Total Seats",
                                    style: GoogleFonts.tinos(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 75, 2, 2),
                                    ),
                                                    ),
                                                            ),
                                    
                                    Padding(
                                    padding: const EdgeInsets.only(left:16.0,right:16.0, top: 6),
                                    child: Text(
                                    "50",
                                    style: GoogleFonts.tinos(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 80, 79, 79)
                                    ),
                                                    ),
                                                            ),
                                  ],
                                ),
                                
                                
                                                        
                                Column(
                                  children: [
                                    Padding(
                                    padding: const EdgeInsets.only(left:16.0,right:16.0, top: 10),
                                    child: Text(
                                    "Balance Seats",
                                    style: GoogleFonts.tinos(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 75, 2, 2),
                                    ),
                                                    ),
                                                            ),
                                    
                                    Padding(
                                    padding: const EdgeInsets.only(left:16.0,right:16.0, top: 6),
                                    child: Text(
                                    "25",
                                    style: GoogleFonts.tinos(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 80, 79, 79)
                                    ),
                                                    ),
                                                            ),
                                  ],
                                ),
                              ],
                            ),
          
          ],),
        )
    );

   
  }
}