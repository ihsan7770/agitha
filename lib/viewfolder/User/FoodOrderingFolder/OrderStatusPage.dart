import 'package:agitha/ControllersFolder/DeliveryBoyRatingController.dart';
import 'package:agitha/ControllersFolder/UserOrderStatusController.dart';
import 'package:agitha/ModelsFoder/DeliveryBoyRatingModel.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/User/MyOrdersFolder/PendingOrderFoodDeratils.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/UserProfile.dart';
import 'package:agitha/viewfolder/Widgets/donts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderStatousPage extends StatefulWidget {
  const OrderStatousPage({super.key});

  @override
  State<OrderStatousPage> createState() => _OrderStatousPageState();
}

class _OrderStatousPageState extends State<OrderStatousPage> {
   bool dialogShown = false;
   
double selectedRating = 0;
final TextEditingController reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   String? deliveryBoyId;
  // phone calling 
   Future<void> callNumber(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

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
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  PendingOrderfoodPage()  ),);
          },
        ),
      ),

      body:SingleChildScrollView(
        child: Column(children: [
         


           StreamBuilder<List<Map<String, dynamic>>>(
            stream: orderProvider.currentUserOrdersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No Orders"));
              }

              final orders = snapshot.data!;

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final items =  (order["items"] ?? []) as List;
                  final orderId = order["orderId"] ?? order["id"];
                      final status = order["deliverystatous"] ?? "";

                  // Extract restaurantId from any item (Filtered items already belong to one restaurant)
                  final restaurantId = items.first["restaurantId"];

                      double total = 0;
              for (var item in items) {
                double price = (item["price"] ?? 0).toDouble();
                int qty = item["quantity"] ?? 1;
                total += price * qty;
              }
              total=total+order['tip'];

                  return   // 🔥 Restaurant Details Stream
                          StreamBuilder<Map<String, dynamic>?>(
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
            if (status != "order_delivered")
             Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, ),
            child:Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          const Icon(
              CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 26,
          ),
          const SizedBox(width: 10),
          Text(
            "Order Placed Successfully",
            style: GoogleFonts.tinos(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
         
        ],
            ),
          ),
        )
        
        
          ),
            Container(
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
                  ],
                ),
              ),
                   //date time             
            Padding(
  padding: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 8.0),
  child: Align(
    alignment: Alignment.topLeft,
    child: Text(
      "Order Placed: ${DateFormat('EEEE, hh:mm a, yyyy').format(
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
                          return Container(
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
                          );
                        }).toList(),
                      ),

                      if ((order['tip'] ?? 0) > 0)
                           Padding(
                            padding: const EdgeInsets.only(left: 12.0,top:6,bottom: 6.0,right: 16.0),
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


                       Padding(
                         padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 8.0,bottom: 8.0),
                         child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                 "Total",
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                                ),
                              ),
                                        
                              Text(
                               total.toString(),
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                             
                            ],
                          ),
                       ),

 StreamBuilder<Map<String, dynamic>?>(
  stream: orderProvider.deliveryBoyForOrderStream(orderId),
  builder: (context, snapshot) {
    final status = order["deliverystatous"] ?? "";

    // 🟢 Order Delivered
    if (status == "order_delivered") {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 1.2),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Order Delivered Successfully 🎉",
                style: GoogleFonts.tinos(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 🟡 Otherwise show delivery boy details
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: PreparingLoader(
            fontSize: screenWidth * 0.035,
            color: Colors.green,
          ),
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: PreparingLoader(
            fontSize: screenWidth * 0.035,
            color: Colors.green,
          ),
        ),
      );
    }

    final data = snapshot.data!;
     deliveryBoyId = data["deliveryBoyId"]??"";

    // Delivery Boy Container (your existing UI)
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delivery Details",
              style: GoogleFonts.tinos(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Reach in ${order['deliverytime']} minutes",
              style: GoogleFonts.tinos(
                fontSize: screenWidth * 0.035,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["db_name"] ?? "No Name",
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data["db_phone"] ?? "No Number",
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.035,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    callNumber(data["db_phone"]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Call"),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  },

  //alert streme


  







),


                      
StreamBuilder<bool>(
  stream: orderProvider.streamOrderDelivered(orderId),
  builder: (context, snapshot) {
    if (snapshot.hasData && snapshot.data == true && !dialogShown) {
      dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setLocalState) {
                return AlertDialog(
                    backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: Column(
                    children: const [
                      Icon(Icons.check_circle,
                          color: Colors.green, size: 50),
                      SizedBox(height: 10),
                      Text("Order Delivered Successfully!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 6),
                      Text("How was your delivery experience?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RatingBar.builder(
                          initialRating: selectedRating,
                          minRating: 1,
                          itemSize: 30,
                          allowHalfRating: false,
                          itemCount: 5,
                          unratedColor: Colors.grey,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setLocalState(() {
                              selectedRating = rating;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        Consumer<DeliveryBoyRatingProvider>(
                          builder: (context, provider, _) {
                            return TextFormField(
                              controller: reviewController,
                              validator: (v) => v!.isEmpty
                                  ? "Please write your delivery experience"
                                  : null,
                              decoration: InputDecoration(
                                hintText: "Share your delivery experience",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: provider.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
                                          Icons.send,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  onPressed: provider.isLoading
                                      ? null
                                      : () async {
                                          if (selectedRating == 0) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Please select a rating"),
                                              ),
                                            );
                                            return;
                                          }

                                          if (!_formKey.currentState!
                                              .validate()) return;

                                          final model = DeliveryBoyRatingModel(
                                            userId: "",
                                            docId: "",
                                            dboyId: deliveryBoyId ?? '',
                                            profileImageUrl: "",
                                            username: "",
                                            rating: selectedRating,
                                            review:
                                                reviewController.text.trim(),
                                          );

                                          await provider
                                              .AddDeliverBoyRating(model);

                                          await provider
                                              .updateAverageRatingDeliveryBoy(
                                                  deliveryBoyId ?? '');

                                          reviewController.clear();
                                          selectedRating = 0;

                                          
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  PendingOrderfoodPage()),);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Thanks for your feedback ❤️"),
                                            ),
                                          );
                                        },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      });
    }

    return const SizedBox.shrink();
  },
)







                  



            



          ],
        );

          



                          




                            },
                          );


                  
                  
                  
                  
         
                },
              );
            },
          ),
        //restourent details

         

                          












          
          



         
        
          
        
        
        
          
        
        
        ],),
      )
      
      
    );
  }
}