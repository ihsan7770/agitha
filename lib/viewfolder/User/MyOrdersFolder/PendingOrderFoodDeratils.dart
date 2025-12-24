import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/UserOrderStatusController.dart';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/OrderStatusPage.dart';
import 'package:agitha/viewfolder/User/MyOrdersFolder/TotalFoodOrderDetails.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/UserProfile.dart';
import 'package:agitha/viewfolder/Widgets/donts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingOrderfoodPage extends StatelessWidget {
   PendingOrderfoodPage({super.key});

  // phone calling 
   Future<void> callNumber(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
  bool hasAlertShown = false;

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
        final colorScheme = Theme.of(context).colorScheme;
        final orderProvider = Provider.of<UserOrderStatusProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfile()  ),);
          },
        ),
      ),

      body:SingleChildScrollView(
        child: Column(children: [

          
       
           StreamBuilder<List<Map<String, dynamic>>>(
            stream: orderProvider.notdeliveredcurrentUserOrdersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
           
       if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: orderProvider.previousUserOrdersStream(),
    builder: (context, prevSnapshot) {
      final hasPreviousOrders =
          prevSnapshot.hasData && prevSnapshot.data!.isNotEmpty;

      return SizedBox(
        height: hasPreviousOrders
            ? MediaQuery.of(context).size.height * 0.45 // 🔹 half screen
            : MediaQuery.of(context).size.height * 0.75, // 🔹 center screen
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/noorder.png",
                height: 250,
                width: 250,
              ),
              const SizedBox(height: 10),
              const Text(
                "Orders are empty",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    },
  );
}

           
              final orders = snapshot.data!;
           
              return
              
               ListView.builder(
                itemCount: orders.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final items =  (order["items"] ?? []) as List;
                  final orderId = order["orderId"] ?? order["id"];
                  
           
                  // Extract restaurantId from any item (Filtered items already belong to one restaurant)
                  final restaurantId = items.first["restaurantId"];
           
                      double total = 0;
              for (var item in items) {
                double price = (item["price"] ?? 0).toDouble();
                int qty = item["quantity"] ?? 1;
                total += price * qty;
              }
              total= total+order["tip"];
           
                  return   // 🔥 Restaurant Details Stream
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              surfaceTintColor: Colors.white,
                              child: StreamBuilder<Map<String, dynamic>?>(
                                stream: orderProvider.singleRestaurantDetails(restaurantId),
                                builder: (context, restSnapshot) {
                                  if (restSnapshot.connectionState == ConnectionState.waiting) {
                                    return const Text("Loading...");
                                  }
                                         
                                  if (!restSnapshot.hasData) {
                                    return const Text("Restaurant not found");
                                  }
                                         
                                  final restaurant = restSnapshot.data!;
                                         
                                  return 
                                                 Column(
                                                   children: [
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text("Current Order",style: GoogleFonts.tinos(
                                                        fontSize: screenWidth * 0.05,
                                                        fontWeight: FontWeight.bold,
                                                      ),),
                                                    ),
                                                     const SizedBox(height: 10,),
                                                     
                                          
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(12),
                                                      child: Image.network(
                                                       restaurant["restaurantImageUrl"] ?? "No Name",
                                                        width: screenWidth * 0.20,
                                                        height: screenWidth * 0.20,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                                          Text(
                                                                            restaurant["restaurantName"] ?? "No Name",
                                                                            style: GoogleFonts.tinos(
                                                                              fontSize: screenWidth * 0.045,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                          
                                                                          Text(
                                                                            restaurant["location"] ?? "No Location",
                                                                            style: GoogleFonts.tinos(
                                                                              fontSize: screenWidth * 0.04,
                                                                              fontWeight: FontWeight.w200,
                                                                              color: Colors.grey,
                                                                            ),
                                                                          ),
                                                                          
                                            
                                                         const SizedBox(height: 8),
                                                      
                                                        ],
                                                      ),
                                                    ),

                                                    InkWell(
                                                      onTap: () {
                                                   Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderStatousPage()),);
                                                      },
                                                      child: Text("View More",style: GoogleFonts.tinos(
                                                        fontSize: screenWidth * 0.035,
                                                        color: colorScheme.primary,
                                                      ),),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                          ),
                                                //  date time             
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      "Ordered: ${DateFormat('EEEE, hh:mm a, yyyy').format(
                                                      (order['createdAt'] as Timestamp).toDate(),
                                    )}",
                                                      style: GoogleFonts.tinos(
                                                           fontSize: screenWidth * 0.035,
                                                         color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                         
                                Column(
                                                      children: items.map<Widget>((item) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0,),
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.circle, size: 8),
                                          const SizedBox(width: 6),
                                          Text(
                                            item['dishName']?.toString() ?? "No Name",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: Text(
                                          "Quantity: ${item['quantity'] ?? 1}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                                                      }).toList(),
                                                    ),
                              
                                                     
                                         SizedBox(height: 20),
                                              
                                         
                                         
                                                   ],
                                                 );
                                         
                                                   
                                         
                                         
                                         
                              
                                         
                                         
                                         
                                         
                                },
                              ),
                            ),
                          );
           
           
                  
                  
                  
                  
                    
                },
              );
            },
                     ),
        
        
        
           ///prevous order
      
        
        
        
        
        
           StreamBuilder<List<Map<String, dynamic>>>(
  stream: orderProvider.previousUserOrdersStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return const Center(child: Text("No previous orders"));
    }

    final orders = snapshot.data ?? [];

    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    // 🔥 Reverse orders so latest comes first
    final reversedOrders = orders.reversed.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Title
        Padding(
          padding: const EdgeInsets.only(left: 12.0, top: 8.0),
          child: Text(
            'Previous Orders',
            style: GoogleFonts.tinos(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        /// 🔹 Orders List
        ListView.builder(
          itemCount: reversedOrders.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final order = reversedOrders[index];
            final items =
                List<Map<String, dynamic>>.from(order['items'] ?? []);
            // final deliveryBoy = order['deliveryBoy'];
            final restaurant = order['restaurant'];

            double total = 0;
            for (var item in items) {
              double price = (item["price"] ?? 0).toDouble();
              int qty = item["quantity"] ?? 1;
              total += price * qty;
            }
            total=total+order['tip'];

            return InkWell(
              onTap: () {
                
               Navigator.push(context, MaterialPageRoute(builder: (context) =>  TotalFoodOrderDetails(
                orderId: order['id'],
                
                
                
                )),);
                print("order id  :${order['id']}");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              
                        /// 🔹 Restaurant Section
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                restaurant['restaurantImageUrl'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant['restaurantName'] ?? "Restaurant",
                                    style: GoogleFonts.tinos(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    restaurant['location'] ?? "No Location",
                                    style: GoogleFonts.tinos(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

 InkWell(
  onTap: () {
    final cartController =
        Provider.of<CartController>(context, listen: false);

    final List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(order['items']);

    // 🔥 Optional: Clear old cart before reorder
    cartController.clearCart();

    for (var item in items) {
      final cartItem = CartItem(
        dishName: item['dishName'],
        price: (item['price'] ?? 0).toDouble(),
        quantity: item['quantity'] ?? 1,
        restaurantId: item['restaurantId'],
        companyName: item['companyName'], // or restaurant name
        dishPhoto: item['dishPhoto'] ?? '',
      );

      cartController.addToCart(
        cartItem,
        onDifferentRestaurant: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "You can order from only one restaurant at a time",
              ),
            ),
          );
        },
      );
    }

    // 🔥 Navigate to Home / Cart
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  },
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: colorScheme.primary,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Text(
      "Reorder",
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
),

                          ],
                        ),
              
                        const SizedBox(height: 15),
              
                        /// 🔹 Items
                        Column(
                          children: items.map((item) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.circle, size: 8),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['dishName'] ?? "Item",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 16, top: 4),
                                    child: Text(
                                      "Qty: ${item['quantity'] ?? 1}",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
              
                        // / 🔹 Order Date
                 Padding(
                     padding: const EdgeInsets.only(top: 10),
                     child: Text(
                       "Ordered: ${DateFormat(
                         'MMMM d, yyyy – hh:mm a',
                       ).format((order['createdAt'] as Timestamp).toDate())}",
                       style: GoogleFonts.tinos(
                         fontSize: screenWidth * 0.035,
                         color: Colors.grey,
                     ),
                     ),
                   ),

              
                        const SizedBox(height: 10),
              
                        /// 🔹 Status + Total
                        Row(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Delivered",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 6, 98, 9),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(
                                  Icons.check_circle,
                                  color: Color.fromARGB(255, 6, 98, 9),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((order['tip'] ?? 0) > 0)
                            Text(
                                  "Tip: ₹${order['tip']}",
                                  style: GoogleFonts.tinos(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
              
                                Text(
                                  "Total: ₹$total",
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
              
                        
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  },
)

        
        
        
         
        
            
        
        
        
          
        
        
        ],),
      )
      
      
    );
  }
}