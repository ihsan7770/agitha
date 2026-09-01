import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/DeliveryBoyDetails.dart';
import 'package:agitha/viewfolder/Admin/RestorentFolder/VeiwExtraRestourentDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewDeliveryBoys extends StatefulWidget {
  const ViewDeliveryBoys({super.key});

  @override
  State<ViewDeliveryBoys> createState() => _ViewDeliveryBoysState();
}

class _ViewDeliveryBoysState extends State<ViewDeliveryBoys> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DeliveryBoyViewProvider>().fetchDeliveryBoyWithEmails();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Reject Alert
    void dbDeleteAlert(BuildContext context, String docId, String name) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reject Delivery Boy'),
          content: Text('Are you sure you want to reject $name?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')
            ),
            ElevatedButton(
                   style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
              onPressed: () async {
                await context.read<DeliveryBoyViewProvider>()
                    .declineDeliveryBoy(docId);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name rejected successfully'),
                        backgroundColor: colorScheme.primary)
                );
              },
              child: const Text('Reject',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
    }

    // Approve Alert
    void dbApproveAlert(BuildContext context, String docId, String name) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Approve Delivery Boy'),
          content: Text('Are you sure you want to approve $name?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')
            ),
            ElevatedButton(
                   style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
              onPressed: () async {
                await context.read<DeliveryBoyViewProvider>()
                    .approveDeliveryBoy(docId);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$name approved successfully'),
                        backgroundColor: colorScheme.primary)
                );
              },
              child: const Text('Approve',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      );
    }


 final screenWidth = MediaQuery.of(context).size.width;
 final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Delivery Boys List"),
        centerTitle: true,
      ),
    
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: context.read<DeliveryBoyViewProvider>()
            .streamPendingAndApprovedDeliveryBoys(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final deliveryBoys = snapshot.data!;
          if (deliveryBoys.isEmpty) {
            return const Center(child: Text("No Delivery Boys found"));
          }

          return ListView.builder(
  padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
  itemCount: deliveryBoys.length,
  itemBuilder: (context, index) {
    final db = deliveryBoys[index];

    final name = db['db_name'] ?? 'Unknown Delivery Boy';
    final email = db['email'] ?? 'No email';
    final location = db['db_location'] ?? 'No location';
    final userId = db['userId'] ?? '';
    final docId = db['docId'];

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: InkWell(
        onTap: userId.isNotEmpty
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeliveryBoyDetails(
                      deliverboyemail: email,
                      deliveryboyId: userId,
                    ),
                  ),
                );
              }
            : null,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: screenWidth * 0.03,
                offset: const Offset(2, 3),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.006),
                Text(
                  email,
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight * 0.004),
                Text(
                  location,
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.038,
                    color: Colors.grey,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                Row(
                  children: [

                  

                           SizedBox(
                      width:screenWidth * 0.28,   // compact width
                      height: screenWidth * 0.085, // compact height
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth* 0.04),
                          ),
                        ),
                        onPressed: () => dbDeleteAlert(
                          context,
                          docId,
                          name,
                        ),
                        child: Text(
                          "Reject",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize:screenWidth * 0.026, // smaller text
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
              



                    SizedBox(width: screenWidth * 0.05),



                    StreamBuilder<bool>(
  stream: Provider.of<DeliveryBoyViewProvider>(
    context,
    listen: false,
  ).checkDeliveryBoyApprovedStream(docId),
  builder: (context, snapshot) {
    final isApproved = snapshot.data ?? false;

    return  SizedBox(
                          width: screenWidth * 0.3,   // smaller width
                          height: screenWidth * 0.1,// responsive button height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApproved
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth* 0.05), // responsive radius
                              ),
                            ),
                            onPressed: isApproved
                                ? null
                                : () {
                                    dbApproveAlert(
                                      context,
                                      docId,
                                      name,
                                    );
                                  },
                            child: Text(
                              isApproved ? "Approved" : "Approve",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.026, // responsive text size
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
    
    


          },
        )



                         ],
                       ),
                     ],
                   ),
                 ),
               ),
             ),
           );
         },
       );



        },
      ),



    );
  }
}
