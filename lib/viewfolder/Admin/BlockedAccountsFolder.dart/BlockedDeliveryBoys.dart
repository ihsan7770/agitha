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
                  padding: const EdgeInsets.all(16.0),
                  itemCount: deliveryBoys.length,
                  itemBuilder: (context, index) {
                    final deliveryboys = deliveryBoys[index];

                    // Safe null handling
                    final db_name = deliveryboys['db_name']?.toString() ?? 'Unknown Delivery Boy';
                    final db_location = deliveryboys['db_location']?.toString()?? 'Unknown location';

                    final email = deliveryboys['email']?.toString() ?? 'No email available';
                    final userId = deliveryboys['userId']?.toString();
                    final docId = deliveryboys['docId']?.toString();

                    return
      
      
      
      
      
      
      
      
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
          
            child: InkWell(
            onTap: () {
              

              Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => DeliveryBoyDetails(
                  deliveryboyId: userId ?? '',
                  deliverboyemail: email,
                  )),
              );
              },
            child: Container(
              
              width: double.infinity,
              decoration:  BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 16,
                        offset: const Offset(4,4)
                      )
                    ] ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                         
                          Align(
                            alignment: Alignment.topRight,
                            child: Text("${index + 1}.", style: GoogleFonts.tinos(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),),
                          ),
                          const SizedBox(width: 20,),


                          Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                          
                           children: [ 
                            
                             Text(
                              db_name ,
                             style: GoogleFonts.tinos(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 75, 2, 2),
                                                    ),
                                                  ),
                              Text(
                             email ,
                             style: GoogleFonts.tinos(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              
                                                    ),
                             softWrap:true,
                             overflow: TextOverflow.visible,
                                                   
                                                ),


                                                     Text(
                             db_location ,
                             style: GoogleFonts.tinos(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                              
                                                    ),
                             softWrap:true,
                             overflow: TextOverflow.visible,
                                                   
                                                ),

                                        // Show debug info
                                      if (userId == null || userId.isEmpty) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          "No User ID available",
                                          style: GoogleFonts.tinos(
                                            fontSize: 12,
                                           
                                          ),
                                        ),
                                      ],


                            //  const SizedBox(height: 20,),
                                   
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,),
                                      child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: colorScheme.primary,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                      ),
                                                     onPressed: () {
                                                    
                                                         dbApproveAlert(context, docId!, db_name);
                                              
                                                        },
                                      
                                      
                                                      child: const Text("Approve", style: TextStyle(color: Colors.white)),
                                                    ),
                                    ),






                   ],),
                        ],
                      ),
                    ),
            
            
            ),
          ),
        )
        ],
      );
      }
              );
  },
),

               


    );
  }
}