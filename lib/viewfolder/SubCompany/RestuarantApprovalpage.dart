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

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

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
    body: provider.restaurantLoading
        ? const Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
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

              /// ================= APPROVED =================
              if (status == 'approved') {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(
                          "Congratulations!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.085,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        Text(
                          "Your application approved successfully.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Image.asset(
                          'assets/pop.png',
                          width: screenWidth * 0.6,
                          height: screenWidth * 0.6,
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08),
                          child: const Text(
                            "Agitha proudly welcomes the restaurant as a new partner, looking forward to a successful collaboration.",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

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
                              MaterialPageRoute(
                                  builder: (_) => const CompanyMainPage()),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.08,
                              vertical: screenHeight * 0.015,
                            ),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.045),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              /// ================= REJECTED =================
              else if (status == 'rejected') {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Image.asset(
                          'assets/wrong.png',
                          width: screenWidth * 0.5,
                          height: screenWidth * 0.5,
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Text(
                          "Approval Rejected!",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.075,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06),
                          child: const Text(
                            "Unfortunately, your restaurant does not meet the required criteria for approval.",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              /// ================= PENDING =================
              else {
                return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [

                              Image.asset(
                                'assets/correct.png',
                                width: screenWidth * 0.5,
                                height: screenWidth * 0.5,
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              Text(
                                "Registration Successful!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.075,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        screenWidth * 0.05),
                                child: const Text(
                                  "It will take a few seconds to check and approve...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              bottom: screenHeight * 0.06),
                          child: SizedBox(
                            width: double.infinity,
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              backgroundColor:
                                  Colors.green.shade100,
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

