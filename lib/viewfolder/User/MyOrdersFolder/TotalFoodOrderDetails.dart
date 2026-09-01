import 'package:agitha/ControllersFolder/DeliveryBoyRatingController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/ControllersFolder/RestaurantRatingController.dart';
import 'package:agitha/ModelsFoder/DeliveryBoyRatingModel.dart';
import 'package:agitha/ModelsFoder/RestaurantReviewModel.dart';
import 'package:agitha/viewfolder/User/MyOrdersFolder/FoodRatingpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TotalFoodOrderDetails extends StatefulWidget {
  final String orderId;

  const TotalFoodOrderDetails({super.key, required this.orderId,});

  @override
  State<TotalFoodOrderDetails> createState() => _TotalFoodOrderDetailsState();
 

}

class _TotalFoodOrderDetailsState extends State<TotalFoodOrderDetails> {
   



    

  // 
  double dbRating = 0; 
  double rating = 0;
  bool showRatingError = false;
  bool showReviewError = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController reviewController = TextEditingController();
  TextEditingController dbreviewController = TextEditingController();
  
String formatOrderCount(int count) {
  if (count >= 1000000) {
    return "${(count / 1000000).floor()}M+";
  } else if (count >= 1000) {
    return "${(count / 1000).floor()}K+";
  } else if (count >= 10) {
    return "${(count / 10).floor() * 10}+";
  } else {
    return "$count"; // no + for less than 10
  }
}



    @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
     final restaurantRatingController = Provider.of<RestaurantRatingProvider>(context, listen: false);

      
    
     
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: OrderController().totalPreviousOrderByIdStream(widget.orderId),
        builder: (context, snapshot) {

          /// ⏳ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ ERROR
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          /// ❌ NO DATA
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No order found"));
          }

          

          final data = snapshot.data!;

          final company = data['company'] as Map<String, dynamic>?;
          final deliveryBoy = data['deliveryBoy'] as Map<String, dynamic>?;

          final List items = data['items'] ?? [];
          // final double total = (data['total'] ?? 0).toDouble();
            double total = 0;
            for (var item in items) {
              double price = (item["price"] ?? 0).toDouble();
              int qty = item["quantity"] ?? 1;
              total += price * qty;
            }
            total=total+data['tip'];

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [

                /// 🏪 COMPANY DETAILS
                if (company != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                company['logoUrl'] ?? '',
                              ),
                            ),
                            title: Text(
                              company['restaurantName'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 23),
                            ),
                            subtitle: Text(
                              company['location'] ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.orange, size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                ((company['rating'] ?? 0).toDouble()).toStringAsFixed(1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                 ),
                          
                                ],
                              ),
                            ),
                          ),

                     
                       
                         Padding(
                           padding: const EdgeInsets.only(left: 16.0,top: 12.0),
                           child: Align(
                            alignment: Alignment.topLeft,
                             child: Text("Rate ${company['restaurantName']}",style: GoogleFonts.roboto(
                              color:Colors.black54,
                              fontSize:16,
                              fontWeight:FontWeight.w400
                             ),),
                           ),
                         ),
                         InkWell(
  borderRadius: BorderRadius.circular(12),
  onTap: () {
     
   showDialog(
    context: context,
    useRootNavigator: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.zero,
            content: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    
                         Padding(
                           padding: const EdgeInsets.only(left: 8.0,top: 12.0),
                           child: Align(
                            alignment: Alignment.topLeft,
                             child: Text("Your rating?",style: GoogleFonts.tinos(
                              color:Colors.black,
                              fontSize:25,
                              fontWeight:FontWeight.w500
                             ),),
                           ),
                         ),

                  const SizedBox(height: 12),

                  /// ⭐ RATING STARS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                            showRatingError = false;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: showRatingError ? Colors.red : Colors.amber,
                          size: showRatingError ? 38 : 32,
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 8),

           

                  
                      /// ✍ REVIEW FIELD
                 TextFormField(
                    controller: reviewController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Write your review...",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      errorText: showReviewError ? "Review cannot be empty" : null,
                  
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: showReviewError ? Colors.red : colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                  
                      /// 📤 SEND BUTTON INSIDE FIELD
                      suffixIcon: IconButton(
                          icon: restaurantRatingController.isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
      : const Icon(Icons.send),
                        color: colorScheme.primary,
                      onPressed: () async {
                                           setState(() {
                    showRatingError = rating == 0;
                    showReviewError = reviewController.text.trim().isEmpty;
                  });
                  
                  if (showRatingError || showReviewError) return;
                  
                  // create model
                  final model = RestaurantReviewModel(
                    docId: "",
                    restaurantId: company['userId'],
                    profileImageUrl: "",
                    username: "",
                    rating: rating,
                    review: reviewController.text.trim(),
                  );
                  
                  // send to firestore
                  await restaurantRatingController.AddRestaurantRating(model);
                  await restaurantRatingController
                      .updateAverageRatingRestaurant(company['userId']);
                  
                  print(company['userId']);
                  
                  // ✅ clear UI AFTER successful submit
                  reviewController.clear();
                  
                  setState(() {
                    rating = 0;               // ⭐ reset stars
                    showRatingError = false;  // hide errors
                    showReviewError = false;
                  });
                  
                  // ✅ close dialog / bottom sheet
                  Navigator.pop(context);
                                              
                                            },
                      ),
                  
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                    ),
                  ),


                  const SizedBox(height: 20),

            
                ],
              ),
            ),
          );


        },




      );
    },
  );
  },
  child: Align(
    alignment: Alignment.topLeft,
    child: Container(
      padding: const EdgeInsets.only(left: 12.0,top:6,bottom: 6.0),
     
      child: RatingBarIndicator(
        rating: 0, // static stars
        itemBuilder: (context, index) => const Icon(
          Icons.star_border,
          color: Colors.amber,
        ),
        itemCount: 5,
        itemSize: 24,
        direction: Axis.horizontal,
      ),
    ),
  ),
),


                          const SizedBox(height: 10,)

                




                        ],
                      ),
                    ),
                  ),

                /// 🔹 ORDER DETAILS TITLE
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Order Details",
                      style: GoogleFonts.tinos(
                          color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ),

                /// 📦 ORDER CARD
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 4,
                  margin: const EdgeInsets.only(left: 14.0,right: 14.0,top:10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                     

                        const SizedBox(height: 10),

                        /// 🍔 ITEMS
                        Column(
                          children: items.map<Widget>((item) {
                            final double price =
                                (item['price'] ?? 0).toDouble();
                            final int qty = item['quantity'] ?? 1;
                            final double subTotal = price * qty;

                            return InkWell(
                              onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context) =>  FoodItemPage (dishid: item["dishId"],)),);
                                
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['dishName'] ?? '',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Text("₹$price"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Qty: $qty",
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                        const Spacer(),
                                        Text("Total: ₹$subTotal",
                                            style: const TextStyle(
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const Divider(height: 20),

                        /// ✅ STATUS + TOTAL
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                                               
                            children: [
                            if ((data['tip'] ?? 0) > 0)
                             Text("Tip: ₹${data['tip']}"),
                              Text(
                                "Total: ₹$total",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🛵 DELIVERY BOY DETAILS
                       Padding(
                  padding: const EdgeInsets.only(left: 16, top: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Delivery Boy Details",
                      style: GoogleFonts.tinos(
                          color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ),
                if (deliveryBoy != null)
                
                  Padding(
                    padding: const EdgeInsets.only(left:16.0,right:16.0),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.delivery_dining),
                            ),
                            title: Text(deliveryBoy['db_name'] ?? '',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                            subtitle: StreamBuilder<int>(
  stream:OrderController(). completedOrdersCountStream(deliveryBoy['db_userId']),
  builder: (context, snapshot) {
    final count = snapshot.data ?? 0;
    
// show count
    return Text(
      "${formatOrderCount(count)} orders delivered",
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  },
),

                           
                           
                           
                           
                           
                            trailing: Container(
                           margin: const EdgeInsets.all(8),
                           padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                           decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                          mainAxisSize: MainAxisSize.min,  // 🔥 important → wrap content
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              "4.0",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                                          ),
                                      ),
                          
                          ),
                        
                        ],
                      ),
                    ),
                  ),

        //           
StatefulBuilder(
  builder: (context, setLocalState) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Card(
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Rate ${deliveryBoy!['db_name']} ",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: RatingBar.builder(
                initialRating: dbRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemSize: 24,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                itemBuilder: (context, _) => const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setLocalState(() {
                    dbRating = rating;
                  });
                  print("Selected rating: $dbRating");
                },
              ),
              leading: Icon(Icons.reviews_outlined, color: colorScheme.primary),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 10.0,
                top: 10.0,
              ),
              child: Form(
                key: _formKey,
                child: Consumer<DeliveryBoyRatingProvider>(
                  builder: (context, provider, _) {
                    return TextFormField(
                      controller: dbreviewController,
                      validator: (v) => v!.isEmpty ? "Enter your review" : null,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Write your review...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        suffixIcon: IconButton(
                          icon: provider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                          color: colorScheme.primary,
                          onPressed: provider.isLoading
                              ? null
                              : () async {
                                  if (dbRating == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please select a rating"),
                                      ),
                                    );
                                    return;
                                  }

                                  if (!_formKey.currentState!.validate()) return;

                                  final model = DeliveryBoyRatingModel(
                                    userId: "",
                                    docId: "",
                                    dboyId: deliveryBoy['db_userId'],
                                    profileImageUrl: "",
                                    username: "",
                                    rating: dbRating,
                                    review: dbreviewController.text.trim(),
                                  );

                                  await provider.AddDeliverBoyRating(model);
                                  await provider.updateAverageRatingDeliveryBoy(
                                    deliveryBoy['db_userId'].toString(),
                                  );

                                  // Use local setState to clear fields without rebuilding entire page
                                  setLocalState(() {
                                    dbreviewController.clear();
                                    dbRating = 0;
                                  });
                                

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Thanks for your feedback ❤️"),
                                    ),
                                  );
                                },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
)

//



              ],
            ),
          );
        },
      ),
    );
  }
}
