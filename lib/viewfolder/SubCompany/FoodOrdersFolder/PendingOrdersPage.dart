import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/AvailableDeliveryBoysPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({super.key});

  @override
  State<PendingOrdersPage> createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
    bool isDelivered = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return  Scaffold(
      
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: context.read<OrderController>().userPendingOrdersStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          

 

        

          if (orders.isEmpty) {
            return Center(
              child: Text("No new orders",
                  style: GoogleFonts.tinos(fontSize: 20)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final items = (order["items"] ?? []) as List;
              final deliveryBoy = order['deliveryBoy'];

              // -----------------------------------------------------
              // CALCULATE TOTAL AMOUNT
              // -----------------------------------------------------
              double total = 0;
              for (var item in items) {
                double price = (item["price"] ?? 0).toDouble();
                int qty = item["quantity"] ?? 1;
                total += price * qty;
              }
               total=total+order['tip'];

              return
              
               Stack(
                 children: [ 
                  
                  
                  Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

            Card(
    // margin: EdgeInsets.symmetric(horizontal: 1, vertical: 8),
    child: ListTile(
     

      title: Text(
        "Delivery Status",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

       subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    if (deliveryBoy != null) ...[
      Text(deliveryBoy['db_name'] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.w500)),
      Text(deliveryBoy['db_phone'] ?? "No phone", style: TextStyle(color: Colors.black54)),
//      Text(
//   deliveryBoy['updatedAt'] 
// )



         


    ] else ...[
      Text("Not Assigned Yet", style: TextStyle(color: Colors.orange)),
    ],
  ],
),

      trailing: () {
  final status = order['deliverystatous'];

  if (status == "accepted_Order") {
    return const Text(
      "Accepted Order",
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }

  if (status == "cancelled_Order") {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Reason for Cancellation",
                style: TextStyle(fontSize: 20),
              ),
              content: Text(order['cancelReason'] ?? "No reason provided"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
      child: const Text(
        "Cancelled",
        style: TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
  
if (status == "order_delivered") {



  return const Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check_circle, size: 18, color: Colors.green),
      SizedBox(width: 4),
      Text(
        "Delivered",
        style: TextStyle(
          fontSize: 14,
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}


  // Default case
  return const Text(
    "Pending...",
    style: TextStyle(color: Colors.black),
  );
}(),




    ),
  ),




                        //----------------------------------------------------
                        // HEADER: CUSTOMER NAME + PHONE
                        //----------------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order['username'],
                              style: GoogleFonts.tinos(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(order["userphone"],
                            style: GoogleFonts.tinos(
                                fontSize: 16, color: Colors.black54)),            

                                


                             

                              
                 
                        const SizedBox(height: 18),
                 
                        //----------------------------------------------------
                        // ORDER ITEMS
                        //----------------------------------------------------
                        Text("Items:",
                            style: GoogleFonts.tinos(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                 
                        Column(
                          children: items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.circle,
                                      size: 10, color: Colors.black),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "${item['dishName']}  x${item['quantity']}",
                                      style: GoogleFonts.tinos(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "₹${item['price']}",
                                    style: GoogleFonts.tinos(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                 
                          if ((order['tip'] ?? 0) > 0)
                           Padding(
                            padding: const EdgeInsets.only(left: 17.0,top:6.0,bottom: 8.0),
                            child: Row(children: [
                              Text("Tip:",style: GoogleFonts.tinos(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Text(order['tip'].toString(),style: GoogleFonts.tinos(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ],),
                          ),
                 
                 
                        //----------------------------------------------------
                        // TOTAL PRICE BOX
                        //----------------------------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Text("Total Amount:",
                                  style: GoogleFonts.tinos(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              Text("₹${total.toStringAsFixed(2)}",
                                  style: GoogleFonts.tinos(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ],
                          ),
                        ),
                 
                        const SizedBox(height: 16),
                 
                        //----------------------------------------------------
                        // ACTION BUTTONS
                        //----------------------------------------------------
          
                        
                      ],
                    ),
                  ),
                               ),



                                   
    


 
                               
                               
                               
                                ]
               );
            },
          );
        },
      ),
      
    );
  }
}