import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PreviousOrdersPage extends StatelessWidget {
  const PreviousOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: context.read<OrderController>().userPreviousDeliveredOrdersStream(),
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
        "Delivery Boy",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),

       subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    if (deliveryBoy != null) ...[
      Text(deliveryBoy['db_name'] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.w500)),
      Text(deliveryBoy['db_phone'] ?? "No phone", style: TextStyle(color: Colors.black54)),


       


    ] else ...[
      Text("Not Assigned Yet", style: TextStyle(color: Colors.orange)),
    ],
  ],
),

      trailing: const Row(
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
  )
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
                              padding: const EdgeInsets.only(bottom: 8.0),
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
                 
                        
                        
                 
               Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Order Placed:${DateFormat('MMMM d, yyyy – hh:mm a').format(
                          DateTime.parse(order['createdAt']),
                        )}",
                        style: GoogleFonts.tinos(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                            
                            

                 
                        //----------------------------------------------------
                        // TOTAL PRICE BOX
                        //----------------------------------------------------
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((order['tip'] ?? 0) > 0)
                              Text("Tip: ₹${order['tip'].toString()}",
                                  style: GoogleFonts.tinos(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                             
                              Text("Total: ₹${total.toStringAsFixed(2)}",
                                  style: GoogleFonts.tinos(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                        ),
                 
                        const SizedBox(height: 16),
                 
                    
          
                        
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