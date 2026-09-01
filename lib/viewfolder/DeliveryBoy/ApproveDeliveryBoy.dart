import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyMainPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ApproveDeliveryBoy extends StatefulWidget {
  const ApproveDeliveryBoy({super.key});

  @override
  State<ApproveDeliveryBoy> createState() => _ApproveDeliveryBoyState();
}

class _ApproveDeliveryBoyState extends State<ApproveDeliveryBoy> {
  final DeliveryBoyViewProvider provider = DeliveryBoyViewProvider();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final userId = context.watch<DeliveryBoyViewProvider>().userId;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AuthenticationController().logout(context);
          },
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: provider.getdeliveryBoyStream(userId.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No Deliveryboy data found."));
                }

                final doc = snapshot.data!.docs.first;
                final data = doc.data() as Map<String, dynamic>;
                final status = data['status'] as String? ?? 'pending';

                /// ================= APPROVED =================
                if (status == 'approved') {
                  return SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.1),
                                Text(
                                  "Congratulations!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.085,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 75, 2, 2),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  "Your application approved successfully.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.05),
                                Image.asset(
                                  'assets/pop.png',
                                  width: screenWidth * 0.6,
                                  height: screenWidth * 0.6,
                                ),
                                SizedBox(height: screenHeight * 0.05),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                  ),
                                  child: const Text(
                                    "Agitha proudly welcomes the as a new partner, looking forward to a successful collaboration.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DeliveryBoyMainPage(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.06,
                                          vertical: screenHeight * 0.015,
                                        ),
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.045,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                /// ================= REJECTED =================
                else if (status == 'rejected') {
                  return SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Column(
                        children: [
                          Expanded(
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
                                    horizontal: screenWidth * 0.04,
                                  ),
                                  child: const Text(
                                    "Unfortunately, your details do not meet the required criteria for approval.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ],
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
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                const Text(
                                  "It will take a few seconds to check and approve...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "Your application is pending and will be approved by Agitha shortly",
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          LinearProgressIndicator(
                            minHeight: 6,
                            backgroundColor: Colors.green.shade100,
                            color: Colors.green,
                          ),
                          SizedBox(height: screenHeight * 0.06),
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
