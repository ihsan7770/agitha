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
            padding: const EdgeInsets.all(16),
            itemCount: deliveryBoys.length,
            itemBuilder: (context, index) {
              final db = deliveryBoys[index];

              final name = db['db_name'] ?? 'Unknown Delivery Boy';
              final email = db['email'] ?? 'No email';
              final location = db['db_location'] ?? 'No location';
              final userId = db['userId'] ?? '';
              final docId = db['docId'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                    onTap: userId != null && userId.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryBoyDetails(deliverboyemail: email,deliveryboyId:userId ?? ''),
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
                            blurRadius: 12,
                            offset: const Offset(2, 3))
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: GoogleFonts.tinos(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 5),
                          Text(email,
                              style: GoogleFonts.tinos(
                                  fontSize: 16, color: Colors.grey)),
                          const SizedBox(height: 3),
                          Text(location,
                              style: GoogleFonts.tinos(
                                  fontSize: 15, color: Colors.grey)),
                  
                          const SizedBox(height: 16),
                  
                          Row(
                                children: [
                                  // Reject Button
                                  OutlinedButton(
                                     style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                    onPressed: 
                                        () => dbDeleteAlert(
                                        context, docId, name),
                                    child: const Text(
                                      
                                        "Reject"),
                                  ),
                  
                                  const SizedBox(width: 20),
                  
                   StreamBuilder<bool>(
                    stream: Provider.of<DeliveryBoyViewProvider>(context, listen: false)
                        .checkDeliveryBoyApprovedStream(docId),
                    builder: (context, snapshot) {
                      final isApproved = snapshot.data ?? false;
                  
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isApproved
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: isApproved
                            ? null
                            : () {
                                dbApproveAlert(
                  context,
                  docId,
                  name, // ✅ Already available above
                                );
                              },
                        child: Text(
                          isApproved ? "Approved" : "Approve",
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  )
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
                                ],
                              )
                        
                  
                  
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
