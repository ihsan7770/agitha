import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/viewfolder/Admin/RestorentFolder/VeiwExtraRestourentDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewRestorents extends StatefulWidget {
  const ViewRestorents({super.key});

  @override
  State<ViewRestorents> createState() => _ViewRestorentsState();
}

class _ViewRestorentsState extends State<ViewRestorents> {
  @override
  void initState() {
    super.initState();
 
 }

  // // ❌ Decline Alert
  // void restaurantdeleteAlert(
  //     BuildContext context, String docId, String restaurantName) {
  //           final colorScheme = Theme.of(context).colorScheme;
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Reject Restaurant'),
  //       content: Text('Are you sure you want to Reject $restaurantName?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             try {
  //               await Provider.of<RestaurantViewProvider>(context, listen: false)
  //                   .declineRestaurant(docId);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('$restaurantName rejected successfully'),
  //                 backgroundColor: colorScheme.primary  ,
                  
  //                 ),
  //               );
  //               await Provider.of<RestaurantViewProvider>(context, listen: false)
  //                   .fetchCompaniesWithEmails();
  //               setState(() {});
  //             } catch (e) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Error: $e')),
  //               );
  //             }
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Reject'),
  //         ),
  //       ],
  //     ),
  //   );
  // }


    void restaurantRejectAlert(
    BuildContext context, String docId, String restaurantName) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reject Restaurant'),
      content: Text('Are you sure you want to Reject $restaurantName?'),
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
              await Provider.of<RestaurantViewProvider>(context, listen: false)
                  .declineRestaurant(docId);

              Navigator.pop(context); // Close dialog first ✅

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$restaurantName Rejected successfully'),
                  backgroundColor: colorScheme.primary,
                ),
              );

            } catch (e) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text(
            'Reject',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}




  void restaurantApproveAlert(
    BuildContext context, String docId, String restaurantName) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Approve Restaurant'),
      content: Text('Are you sure you want to approve $restaurantName?'),
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
              await Provider.of<RestaurantViewProvider>(context, listen: false)
                  .approveRestaurant(docId);

              Navigator.pop(context); // Close dialog first ✅

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$restaurantName approved successfully'),
                  backgroundColor: colorScheme.primary,
                ),
              );

            } catch (e) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text(
            'Approve',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
      final Size size = MediaQuery.of(context).size;
      final double w = size.width;
    
          // final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
       appBar:  AppBar(
        title: const Text("Restaurants List"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
  stream: Provider.of<RestaurantViewProvider>(context, listen: false)
      .streamPendingAndApprovedCompanies(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text("No restaurants found"));
    }

    final companies = snapshot.data!;

    return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: companies.length, // ✅ Correct count
              itemBuilder: (context, index) {
              final company = companies[index];
              final restaurantName = company['restaurantName'] ?? 'Unknown Restaurant';
              final email = company['email'] ?? 'No email available';
              final userId = company['userId'];
              final docId = company['docId'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: InkWell(
                        onTap: userId != null && userId.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewExtraRestourentDetails(companyId: userId),
                                  ),
                                );
                              }
                            : null,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
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
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}.",
                                  style: GoogleFonts.tinos(
                                    fontSize:  w * 0.07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                 SizedBox(width:  w * 0.06),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurantName,
                                        style: GoogleFonts.tinos(
                                          fontSize: w * 0.06,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(255, 75, 2, 2),
                                        ),
                                      ),
                                      Text(
                                        email,
                                        style: GoogleFonts.tinos(
                                          fontSize: w * 0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 20),


                                      Row(
                      children: [
                        // Reject Button (no stream needed)
                      SizedBox(
                      width: w * 0.28,   // compact width
                      height: w * 0.085, // compact height
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.04),
                          ),
                        ),
                        onPressed: () => restaurantRejectAlert(
                          context,
                          docId,
                          restaurantName,
                        ),
                        child: Text(
                          "Reject",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: w * 0.026, // smaller text
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                         SizedBox(width: w * 0.04),
                    
                     StreamBuilder<bool>(
                      stream: Provider.of<RestaurantViewProvider>(context, listen: false)
                          .checkRestaurantApprovedStream(docId),
                      builder: (context, snapshot) {
                        final isApproved = snapshot.data ?? false;
                        return SizedBox(
                          width: w * 0.3,   // smaller width
                          height: w * 0.1,// responsive button height
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isApproved
                                  ? Colors.grey
                                  : Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(w * 0.05), // responsive radius
                              ),
                            ),
                            onPressed: isApproved
                                ? null
                                : () {
                                    restaurantApproveAlert(
                                      context,
                                      docId,
                                      restaurantName,
                                    );
                                  },
                            child: Text(
                              isApproved ? "Approved" : "Approve",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.026, // responsive text size
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
