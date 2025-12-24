import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyHomePage.dart';
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
      final userId = context.watch<DeliveryBoyViewProvider>().userId;
    return  Scaffold(
      appBar: AppBar(

  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
            AuthenticationController().logout(context);
    },
  ),
),


      body:provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          :
      
       StreamBuilder<QuerySnapshot>(
        stream: provider.getdeliveryBoyStream(userId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Deliveryboy data found."));
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status'] as String? ?? 'pending';

          if (status == 'approved') {
            // ✅ Approved design
            return   SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Center content
              Expanded(
                child: Column(
              
                  children: [


                    SizedBox(height: 80),

                       Text(
                      "Congratulations!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tinos(
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 75, 2, 2),
                      ),
                    ),

                          Text(
                      "Your application approved successfully.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tinos(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                      ),
                    ),

                    const SizedBox(height: 40),

                    Image.asset(
                      'assets/pop.png',
                      width: 250,
                      height: 250,
                    ),
                  const SizedBox(height: 40),
                   
                    
                    const Text(
                      "Agitha proudly welcomes the as a new partner,looking forward to a successful collaboration.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                        
               Align(
                alignment: 
                Alignment.bottomRight,
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: ElevatedButton(
                   onPressed: () { 
               Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryBoyMainPage()),);

                   },
                   style: ElevatedButton.styleFrom(
                   backgroundColor:
                   Theme.of(context).colorScheme.primary,
                   foregroundColor: Colors.white,
                   shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20),
                   ),
                   ),
                      child: const Text("Next"),
                    ),
                 ),
               )
                  ],
                ),
              ),
          


       
            ],
          ),
        ),
      );
          } else if (status == 'rejected') {
            // ❌ Rejected design
            return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Center content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/wrong.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Approval Rejected!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tinos(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 75, 2, 2),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Unfortunately, your details do not meet the required criteria for approval.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),

       
            ],
          ),
        ),
      );
          } else {
            // ⏳ Pending design
            return  SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Center content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/correct.png',
                      width: 200,
                      height: 200,
                    ),
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
                    const Text(
                      "It will take a few seconds to check and approve...",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),

           
                 Text(
                  "Your application is pending and will be approved by Agitha shortly",
                  style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  minHeight: 6,
                  backgroundColor: Colors.green.shade100,
                  color: Colors.green,
                ),
                const SizedBox(height: 50),
              

       
               
                
              
            ]
          ),
        ),
      );
          }
        },
      ),
    );
  }
}