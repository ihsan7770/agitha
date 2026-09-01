import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/DeliveryBoyDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BlockedDeliveryBoys extends StatefulWidget {
  const BlockedDeliveryBoys({super.key});

  @override
  State<BlockedDeliveryBoys> createState() => _BlockedDeliveryBoysState();
}

class _BlockedDeliveryBoysState extends State<BlockedDeliveryBoys> {
  @override




   void initState() {
    super.initState();
 
  
  }


 // ✅ Approve Alert
void dbApproveAlert(
    BuildContext context, String docId, String deliveryBoyName) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Approve Delivery Boy'),
      content: Text('Are you sure you want to approve $deliveryBoyName?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
               style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
          onPressed: () async {
            try {
              await Provider.of<DeliveryBoyViewProvider>(context, listen: false)
                  .approveDeliveryBoy(docId);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$deliveryBoyName approved successfully'),
                  backgroundColor: colorScheme.primary,
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
            Navigator.pop(context);
          },
          child: const Text('Approve',style: TextStyle(color: Colors.white),),
        ),
      ],
    ),
  );
}


  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final provider = Provider.of<DeliveryBoyViewProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
     return Scaffold(
   
      body: StreamBuilder<List<Map<String, dynamic>>>(
  stream: Provider.of<DeliveryBoyViewProvider>(context, listen: false)
      .streamRejectedDeliveryBoys(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final deliveryBoys = snapshot.data!;

    if (deliveryBoys.isEmpty) {
      return const Center(child: Text("No rejected delivery boys"));
    }

    return ListView.builder(
  padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
  itemCount: deliveryBoys.length,
  itemBuilder: (context, index) {
    final deliveryboy = deliveryBoys[index];

    // Safe null handling
    final dbName = deliveryboy['db_name']?.toString() ?? 'Unknown Delivery Boy';
    final dbLocation = deliveryboy['db_location']?.toString() ?? 'Unknown location';
    final email = deliveryboy['email']?.toString() ?? 'No email available';
    final userId = deliveryboy['userId']?.toString();
    final docId = deliveryboy['docId']?.toString();

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02), // responsive spacing
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryBoyDetails(
                deliveryboyId: userId ?? '',
                deliverboyemail: email,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 16,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}.",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.06, // responsive
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dbName,
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        dbLocation,
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),

                      if (userId == null || userId.isEmpty) ...[
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          "No User ID available",
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],

                      SizedBox(height: screenHeight * 0.015),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                        onPressed: () {
                          if (docId != null) {
                            dbApproveAlert(context, docId, dbName);
                          }
                        },
                        child: Text(
                          "Approve",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
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