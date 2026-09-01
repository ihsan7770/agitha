import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/viewfolder/Widgets/Locationtrack.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:url_launcher/url_launcher.dart';

class AccepedOrderPage extends StatefulWidget {
     String orderId;
   AccepedOrderPage({super.key,required this.orderId});

  @override
  State<AccepedOrderPage> createState() => _AccepedOrderPageState();
}

class _AccepedOrderPageState extends State<AccepedOrderPage> {
// phone calling 
   Future<void> callNumber(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool isSliding = false;

  @override
  Widget build(BuildContext context) {
    final dborderProvider = Provider.of<DeliveryBoyHomeController>(context, listen: false);
     final orderprovider= Provider.of<OrderController>(context, listen: false);

       final Size size = MediaQuery.of(context).size;
       final double screenWidth = size.width;

     final colorScheme = Theme.of(context).colorScheme;
    return  Scaffold(
      appBar: AppBar( ),
      body:StreamBuilder<Map<String, dynamic>?>(
        stream: dborderProvider.streamOrderById(widget.orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "No order found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final order = snapshot.data!;
            final items = (order["items"] ?? []) as List;

              double total = 0;
              for (var item in items) {
                double price = (item["price"] ?? 0).toDouble();
                int qty = item["quantity"] ?? 1;
                total += price * qty;
              }
              total=total+order['tip'];

         return     
      
       SingleChildScrollView(
        child: Column(
          children: [

               Align(
                   alignment: Alignment.topLeft,
                   child: Padding(
                                padding: const EdgeInsets.only(left: 16.0,top: 12.0),
                                child: Text(
                                "Delivery Items",
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                                                ),
                              ),
                                  ),

                                  //first row

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                                        children: items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                   Icon(Icons.circle,
                                        size: screenWidth * 0.04, color: Colors.black),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${item['dishName']}  x${item['quantity']}",
                                        style: GoogleFonts.tinos(
                                          fontSize:screenWidth * 0.05,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "₹${item['price']}",
                                      style: GoogleFonts.tinos(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                                                        }).toList(),
                                                      ),
                            ),

                               if ((order['tip'] ?? 0) > 0)
                           Padding(
                            padding: const EdgeInsets.only(left: 17.0,right: 16.0),
                            child: Row(children: [
                              Text("Tip:",style: GoogleFonts.tinos(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Text(order['tip'].toString(),style: GoogleFonts.tinos(
                                      fontSize:screenWidth * 0.05,
                                      fontWeight: FontWeight.w600))
                            ],),
                          ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                                  child: Row(
                                    children: [
                                  
                                        Text("Total", style: GoogleFonts.tinos(
                                                fontSize:screenWidth * 0.06,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),),
                                              const Spacer(),

                                               Padding(
                                                 padding: const EdgeInsets.only(top:8.0),
                                                 child: Column(
                                                   children: [
                                                   
                                                     Text(total.toString(), style: GoogleFonts.tinos(
                                                      fontSize: screenWidth * 0.06,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black, ),),
                                                 
                                                      Text(order["paymentStatus"], style: GoogleFonts.tinos(
                                                      fontSize: screenWidth * 0.04,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey, ),),
                                                 
                                                 
                                                 
                                                 
                                                                                                  
                                                   ],
                                                 ),
                                               ),
                                  
                                      
                                    ],
                                  ),
                                ),
        
         Align(
                   alignment: Alignment.topLeft,
                   child: Padding(
                                padding: const EdgeInsets.only(left: 16.0,),
                                child: Text(
                                "Delivery Location",
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                                                ),
                              ),
                                  ),
        
                                  LocationImage(destLat: order['latitude'],destLng: order['longitude'],),

                                
              
              
              
        
        
        
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                                     padding: const EdgeInsets.only(left: 16.0,),
                                     child: Text(
                                     "Customer Details",
                                     style: GoogleFonts.tinos(
                                       fontSize: screenWidth * 0.06,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black
                                     ),
                                                     ),
                                   ),
                                       ),
        
        
                                         Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
        
              children: [
                
        
           Padding(
           padding: const EdgeInsets.all(16.0),
           child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: (order['userphone'] != null &&
            order['userphone'].toString().trim().isNotEmpty &&
            order['userphone'].toString().startsWith("http"))
        ? Image.network(
            order['userphone'],
            fit: BoxFit.cover,
            width: screenWidth * 0.20,
            height: screenWidth * 0.20,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                 width: screenWidth * 0.20,
                 height: screenWidth * 0.20,
                color: Colors.grey[300],
                child:  Icon(Icons.person, size: screenWidth * 0.10, color: Colors.black54),
              );
            },
          )
        : Container(
            width: screenWidth * 0.20,
                 height: screenWidth * 0.20,
            color: Colors.grey[300],
            child:  Icon(Icons.person, size:screenWidth * 0.10, color: Colors.black54),
          ),
  ),
),

        
        
        
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 12.0,top: 12.0),
                           child: Text(
                           order['username'],
                           style: GoogleFonts.tinos(
                             fontSize: screenWidth * 0.06,
                             fontWeight: FontWeight.bold,
                             color: Colors.black
                           ),
                                           ),
                         ),
        
                           Padding(
                             padding: const EdgeInsets.only(left: 12.0,),
                             child: Text(
                               order['userphone'],
                             style: GoogleFonts.tinos(
                               fontSize: screenWidth * 0.05,
                               fontWeight: FontWeight.bold,
                               color: Colors.black
                             ),
                                             ),
                           ),
        
        
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: TextButton.icon(onPressed: () {
                                    callNumber(order['userphone']);
                                    
                                  }, icon:  Icon(Icons.phone,color: colorScheme.primary,size: screenWidth * 0.04,), label:  Text("Call",style: TextStyle(fontSize: screenWidth * 0.04,color: colorScheme.primary),),
                                  style: TextButton.styleFrom(
                                    side:  BorderSide(
                                      color:colorScheme.primary,width: 1
                                    )
                                  ),
                                      ),
                           ),

                           const SizedBox(height: 10,),
   
                           
                           ],
                     ),
              ],
            ),
        
            
                          
                          
                          
                          
                          
                          
                          //  Padding(
                          //    padding: const EdgeInsets.only(right: 10.0),
                          //    child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.end,
                                                       
                          //     children: [


                          //       TextButton.icon(onPressed: () {
                          //         callNumber(order['userphone']);
                                  
                          //       }, icon:  Icon(Icons.phone,color: colorScheme.primary), label:  Text("Call",style: TextStyle(fontSize: 16,color: colorScheme.primary),),
                          //       style: TextButton.styleFrom(
                          //         side:  BorderSide(
                          //           color:colorScheme.primary,width: 1
                          //         )
                          //       ),
                          //           ),

                                    
                          //       // const SizedBox(width: 10,),
                                   
                               
                             
                          //       // TextButton.icon(onPressed: () {
                                  
                          //       // }, icon: Icon(Icons.message,color: colorScheme.primary),
                          //       // label:  Text("Message",style: TextStyle(fontSize: 16,color: colorScheme.primary)),
                                
                          //       // style: TextButton.styleFrom(
                          //       //   side: BorderSide(
                          //       //    color: colorScheme.primary,width: 1
                          //       //   )
                          //       // ),
                                
                                
                          //       // )
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                          //     ],
                          //    ),
                          //  ),
        
        
        
        
                                
      Padding(
  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
  child: SlideAction(
    text: "Order Completed",
    textStyle:  TextStyle(color: Colors.white, fontSize: screenWidth * 0.05),
    outerColor: Theme.of(context).colorScheme.primary,
    innerColor: Colors.white,
    onSubmit: () async {

      // 1️⃣ Wait for SlideAction's animation to fully finish
      await Future.delayed(const Duration(seconds: 2));

      // 2️⃣ Now run backend logic
      await dborderProvider.changeOrderStatusToDelivered(widget.orderId);
      await orderprovider.moveOrderToPreviousCollection(widget.orderId);
      DeliveryBoyHomeController().updateAvailability();

      // 3️⃣ Pop safely
      if (context.mounted) {
        Navigator.pop(context);
      }
    },
  ),
),

                     
           const SizedBox(height: 20,),
        
        
        
        
        
        
        
        
        
        
          ],
        ),
      );


    
    

        },
      ),
    );
      
      
      
      
      
      
      
      



  }
}