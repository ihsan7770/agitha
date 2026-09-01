import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/FoodPaymentPage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderConfromationPage extends StatefulWidget {
  const OrderConfromationPage({super.key});

  @override
  State<OrderConfromationPage> createState() => _OrderConfromationPageState();
}

class _OrderConfromationPageState extends State<OrderConfromationPage> {
  String? latestOrderId;
  String? orderStatous;

   void initState() {
    super.initState();
   }

     /// 🔴 COMMON BACK FUNCTION
  Future<bool> _onBackPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Order"),
        content: const Text(
            "Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success =
          await Provider.of<OrderController>(context,
                  listen: false)
              .cancelOrder(latestOrderId!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Order cancelled successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const FoodCartPage()),
        );
      }
    }

    return false; // ❗ Prevent default back
  }
  
  @override
  Widget build(BuildContext context) {
        final orderProvider = context.watch<OrderController>(); // 🌟 Watch provider
        double screenWidth = MediaQuery.of(context).size.width;
        final userId = orderProvider.userId;
             return WillPopScope(
              onWillPop:  _onBackPressed,
               child: Scaffold(
                           appBar: AppBar(
                         
                          leading: IconButton(
               icon: const Icon(Icons.arrow_back),
                        onPressed: _onBackPressed
               
               
               
               
                 ),
               ),
                      body:orderProvider.isLoading
                         ? const Center(child: CircularProgressIndicator())
                         :
                     
                      StreamBuilder<QuerySnapshot>(
                       stream: orderProvider.getOrderStream(userId.toString()),
                       builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return const Center(child: CircularProgressIndicator());
                         }
               
                         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                           return const Center(child: Text("No Order Data Found."));
                         }
               
                        // 🔥 Always pick the latest order
                        final docs = snapshot.data!.docs;
                        docs.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
                        final doc = docs.first;
                        final data = doc.data() as Map<String, dynamic>;
                        final status = data['status'] as String? ?? 'pending';
                        latestOrderId = doc.id; 
                        
               
                        if (status == 'approved') {
                 // ⭐ Navigate directly to Payment Page instead of showing congratulations design
                       WidgetsBinding.instance.addPostFrameCallback((_) {
                       Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) =>  FoodPaymentPage( latestOrderId: latestOrderId!,) ),
                   );
                 });
               
                 return const Center(
                   child: CircularProgressIndicator(), // temporary view while navigating
                 );
               }
               
                else if (status == 'rejected') {
                 
                     Future.delayed(const Duration(seconds: 2), () async {
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const  UserMainPage()));
                        final cartController = Provider.of<CartController>(context, listen: false);
                           await cartController.clearCartOnLogout();
                   });
               
                 
                           // ❌ Rejected design
                           return SafeArea(
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
                         child: Column(
                           children: [
                // Center content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/wrong.png',
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "OOps! Out of Stock",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        ),
                      ),
                      const SizedBox(height: 10),
                       Text(
                        "Unfortunately, The item become out of stock.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
               
                      
                           ],
                         ),
                       ),
                     );
                         } else {
                           // ⏳ Pending design
                           return  SafeArea(
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
                         child: Column(
                           children: [
                // Center content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/correct.png',
                        width: screenWidth * 0.5,
                        height: screenWidth * 0.5,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Order Placed Successful!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "It will take a few seconds to conform",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
               
                     
                     
                    ],
                  ),
                ),
               
                          
                  
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    minHeight: 6,
                    backgroundColor: Colors.green.shade100,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 50),
                
               
                      
                 
                  
                
                           ]
                         ),
                       ),
                     );
                         }
                       },
                     ),
               
               
                   ),
             );
  }
}