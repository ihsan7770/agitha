import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/AcceptedOrderPage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:agitha/viewfolder/DeliveryBoy/PreviousOrderPage.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class DeliverBoyHomePage extends StatefulWidget {
  const DeliverBoyHomePage({super.key});

  @override
  State<DeliverBoyHomePage> createState() => _DeliverBoyHomePageState();
}

class _DeliverBoyHomePageState extends State<DeliverBoyHomePage> {

    final TextEditingController reasonController = TextEditingController();
    final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double padding = screenWidth * 0.04;
    double titleFontSize = screenWidth * 0.07;
    double locationFontSize = screenWidth * 0.05;
    double addressFontSize = screenWidth * 0.045;
    double buttonHeight = screenHeight * 0.06;
    double buttonFontSize = screenWidth * 0.04;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                "assets/map.png",
                fit: BoxFit.cover,
                width: double.infinity,
                height: screenHeight * 0.6,
              ),
            ),

            StreamBuilder<Map<String, dynamic>?>(
              stream: DeliveryBoyHomeController().streamCurrentReceivedOrder(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  //check availability UI 
                  return StreamBuilder<bool>(
              stream: DeliveryBoyHomeController().streamIsAvailable(),
              builder: (context, snapshot) {
            
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
            
                final isAvailable = snapshot.data ?? false;
            
                if (isAvailable) {
                  // 🟢 UI when isAvailable = true
                  return Column(
                    children: [
                      SizedBox(height: 20),
                       Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Your delivery order is on the way!',style: GoogleFonts.tinos(
                              fontSize: 20,
                              color:Colors.grey
                                                    
                                                        ),),
                          ),
                           Image.asset("assets/dbwait.png",height: 160,
                          ),
                      // 👉 Other UI widgets here
                    ],
                  );

                  
                } else {
                  // 🔴 UI when false
                  return      Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 220,width:double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 16,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('Are You Ready to Deliver Orders?',style: GoogleFonts.tinos(
                              fontSize: 25,
                              color:Colors.grey
                                                    
                                                        ),),
                          ),
                              Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0),
              child: SlideAction(
              text: "Yes, I am Ready",
              textStyle: const TextStyle(color: Colors.white, fontSize: 18),
              outerColor: Colors.green,
              innerColor: Colors.white,
              onSubmit: () {
                 DeliveryBoyHomeController().updateAvailability(); 
                
              
              },
                        ),
            ),
                        ],
                      ) ,
                      
                      
                      
                      
                      
                      )


                  );
                }
              },
            );
            
                              
                              
                  
                  
                  
                  
              
                }

                final order = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(padding),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // New Order
                        Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text(
                            "New Order",
                            style: GoogleFonts.tinos(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 75, 2, 2),
                            ),
                          ),
                        ),

                        // Location
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Text(
                            order['housename'],
                            style: GoogleFonts.tinos(
                              fontSize: locationFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 4),

                        // Address
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Text(
                            order['address'],
                            style: GoogleFonts.tinos(
                              fontSize: addressFontSize,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        StreamBuilder<bool>(
                          stream: DeliveryBoyHomeController()
                              .checkOrderApprovedStream(order['id']),
                          builder: (context, statusSnapshot) {
                            bool isApproved = statusSnapshot.data ?? false;

                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: padding),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: buttonHeight,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (!isApproved) {

                                             final provider = Provider.of<DeliveryBoyHomeController>(context, listen: false);

                                           provider .changeOrderStatusToAccepted(order['id']);
                                            
                                        await provider.getTimeFromCurrentLocation(
                                        orderId: order['id'],
                                        destLat: order['latitude'].toDouble(),
                                        destLng: order['longitude'].toDouble(),
                                      );
                                  
                                  


                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => AccepedOrderPage(
                                                orderId: order['id'],
                                              ),
                                            ),
                                          );

                                          





                                        },
                                        child: Text(
                                          isApproved ? "View Order" : "Accept Order",
                                          style: TextStyle(
                                            fontSize: buttonFontSize,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (!isApproved) ...[
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: SizedBox(
                                        height: buttonHeight,
                                        child: OutlinedButton(
                                          onPressed: () async {


                                            showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Order"),
          content: Form(
            key:_formKey ,
            child: TextFormField(
              controller: reasonController,
              maxLines: 3,
               validator: (value) =>
                            value!.isEmpty ? "Enter your reason" : null,
              decoration: const InputDecoration(
                hintText: "Enter reason for cancellation",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
              onPressed: () {

  if (_formKey.currentState!.validate()) {

                
                final reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                 final dbprovider =  Provider.of<DeliveryBoyHomeController>(context,
                   listen: false);

                  dbprovider
                  . changeOrderStatusToCancelled(order['id'].toString(),reason);

                      dbprovider
                  .cancelledOrderReassigned(order['id'].toString());

                                          reasonController.clear();  
      
      
                              dbprovider.setOrderCancelledOrderId();



                  Navigator.pop(context);
                }
  }


              },
              child: const Text("Send",style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );

                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                              color: colorScheme.primary,
                                              width: 1.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Text(
                                            "Cancel Order",
                                            style: TextStyle(
                                              fontSize: buttonFontSize,
                                              color: colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
