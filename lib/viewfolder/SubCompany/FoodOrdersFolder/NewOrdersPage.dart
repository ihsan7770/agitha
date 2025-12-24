import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/AvailableDeliveryBoysPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewOrdersPage extends StatefulWidget {
  const NewOrdersPage({super.key});

  @override
  State<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: context.read<OrderController>().userOrdersStream(),
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

              // -----------------------------------------------------
              // CALCULATE TOTAL AMOUNT
              // -----------------------------------------------------
              double total = 0;
              for (var item in items) {
                double price = (item["price"] ?? 0).toDouble();
                int qty = item["quantity"] ?? 1;
                total += price * qty ;
                
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            padding: const EdgeInsets.only(left: 17.0,top:3,bottom: 8.0),
                            child: Row(children: [
                              Text("Tip:",style: GoogleFonts.tinos(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Text("₹${order['tip'].toString()}",style: GoogleFonts.tinos(
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
                                      fontWeight: FontWeight.w600) ),
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
                        Row(
                          children: [
                            if (order['status'] == "pending")  
                          OutlinedButton(
                   style: OutlinedButton.styleFrom(
                     side: BorderSide(color: colorScheme.primary, width: 1.5),
                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                   ),
                  onPressed: () async {
                   final confirm = await showDialog(
                     context: context,
                     builder: (context) {
                       return AlertDialog(
                         title: const Text("Cancel Order"),
                         content: Text("Are you sure you want to cancel this ${order['username']} order?"),
                         actions: [
                           TextButton(
                             child: const Text("No"),
                             onPressed: () => Navigator.pop(context, false),
                           ),
                           ElevatedButton(
                              style: ElevatedButton.styleFrom(
                           backgroundColor:
                               Theme.of(context).colorScheme.primary,
                         ),
                             child: const Text("Yes",style: TextStyle(color: Colors.white),),
                             onPressed: () => Navigator.pop(context, true),
                           ),
                         ],
                       );
                     },
                   );
                 
                   if (confirm == true) {
                     final messenger = ScaffoldMessenger.of(context); // SAVE CONTEXT HERE
                 
                     await context.read<OrderController>().declineOrder(order['id']);
                 
                     messenger.showSnackBar(
                        SnackBar(
                         content: Text("Order Cancelled Successfully"),
                         backgroundColor:colorScheme.primary,
                       ),
                     );
                   }
                 },
                 
                   child: const Text("Cancel"),
                 ),
                 
                            const Spacer(),
                            StreamBuilder<bool>(
                   stream: context.read<OrderController>().checkOrderConfromedStream(order['id']),
                   builder: (context, snapshot) {
                     final isConfirmed = snapshot.data ?? false;
                 
                     return ElevatedButton(
                       onPressed: isConfirmed
                           ? null // disable button when already approved
                           : () async {
                               final messenger = ScaffoldMessenger.of(context);
                 
                               await context.read<OrderController>().conformOrder(order['id']);
                 
                               messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Order Approved Successfully"),
                    backgroundColor: Colors.green,
                  ),
                               );
                             },
                       style: ElevatedButton.styleFrom(
                         backgroundColor: isConfirmed ? Colors.grey : colorScheme.primary,
                         foregroundColor: Colors.white,
                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                       ),
                       child: Text(
                         isConfirmed ? "Order Confirmed" : "Confirm Order",
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



                                   if (order['status'] == "cancelled")
      Positioned(

        top:0,
        left:0,
        right:0,
        bottom:12,


        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 71, 3, 3).withOpacity(0.75),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  "ORDER CANCELLED",
                  style: GoogleFonts.tinos(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await context.read<OrderController>().deleteOrder(order['id']);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ),
              
                const SizedBox(height: 10,)
            ],

          ),
        ),
      ),


   if (order['paymentStatus'] == "COD" || order['paymentStatus'] == "paid")
  Positioned(
    top: 0,
    left: 0,
    right: 0,
    bottom: 12,

    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),

      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 3, 233, 11).withOpacity(0.30), // Top shade
            Color.fromARGB(255, 3, 233, 11).withOpacity(0.75), // Main color
          ],
        ),
      ),

      child: Stack(
        children: [
          /// Centered TEXT
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  order['paymentStatus'].toUpperCase(),
                  style: GoogleFonts.tinos(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:  Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 4,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                
               
           if ((order['tip'] ?? 0) > 0)
  Text(
    "Given Tip: ₹${order['tip']}",
    style: GoogleFonts.tinos(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      shadows: const [
        Shadow(
          blurRadius: 4,
          color: Colors.black26,
          offset: Offset(1, 1),
        ),
      ],
    ),
  ),




                
              ],
            ),
          ),

          
          Positioned(
            right: 0,
            top: 0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () async {

              Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryBoyListPage(orderId: order['id'] ,)),);
              


              },
           
              child:  Text(
  order['deliverystatous'] == "cancelled_Order"
      ? "Reassign Delivery Boy"
      : "Assign Delivery Boy",
  style: TextStyle(color: Colors.black),
)

            ),
          ),
        ],
      ),
    ),
  )

                               
                               
                               
                                ]
               );
            },
          );
        },
      ),
    );
  }
}
