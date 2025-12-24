import 'dart:async';
import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyMainPage.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantRegistrationStatus extends StatefulWidget {


  const RestaurantRegistrationStatus({super.key, });

  @override
  State<RestaurantRegistrationStatus> createState() => _RestaurantRegistrationStatusState();
}

class _RestaurantRegistrationStatusState extends State<RestaurantRegistrationStatus> {
  
final RestaurantViewProvider provider = RestaurantViewProvider();

  @override
  void initState() {
    super.initState();
  
     Provider.of<RestaurantViewProvider>(context, listen: false);
  
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;


         
      final userId = context.watch<RestaurantViewProvider>().userId;




    return Scaffold(
      appBar: AppBar(

  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
            AuthenticationController().logout(context);
    },
  ),
),


      body:provider.restaurantLoading
          ? const Center(child: CircularProgressIndicator())
          :
      
       StreamBuilder<QuerySnapshot>(
        stream: provider.getRestaurantStream(userId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No registration data found."));
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status'] as String? ?? 'pending';

          if (status == 'approved') {
            // ✅ Approved design
            return Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Congratulations!",
          textAlign: TextAlign.center,
          style: GoogleFonts.tinos(
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 75, 2, 2),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Your application approved successfully.",
          textAlign: TextAlign.center,
          style: GoogleFonts.tinos(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 20),
        Image.asset('assets/pop.png', width: 250, height: 250),
        const SizedBox(height: 25),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Agitha proudly welcomes the restaurant as a new partner, looking forward to a successful collaboration.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
      backgroundColor:
      Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      ),
      ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompanyMainPage()),
            );
          },
        
          child: const Text("Next"),
        )
      ],
    ),
  ),
);


          } else if (status == 'rejected') {
            // ❌ Rejected design
            return Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/wrong.png', width: 200, height: 200),
        const SizedBox(height: 20),
        Text(
          "Approval Rejected!",
          textAlign: TextAlign.center,
          style: GoogleFonts.tinos(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 75, 2, 2),
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Unfortunately, your restaurant does not meet the required criteria for approval.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    ),
  ),
);


          } else {
            // ⏳ Pending design
          return SafeArea(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ✅ Centered content
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/correct.png', width: 200, height: 200),
              const SizedBox(height: 20),
              Text(
                "Registration Successful!",
                textAlign: TextAlign.center,
                style: GoogleFonts.tinos(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "It will take a few seconds to check and approve...",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),

        // ✅ Bottom Center Progress Bar
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: SizedBox(
            width: double.infinity,
            child: LinearProgressIndicator(
              minHeight: 6,
              backgroundColor: Colors.green.shade100,
              color: Colors.green,
            ),
          ),
        ),
      ],
    ),
  ),
);


          }
        },
      ),
    );
  }
}
