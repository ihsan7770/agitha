import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            return const Center(
              child: Text("No previous orders",
                 ),
            );
          }

          return ListView.builder(
  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final order = orders[index];
    final items = (order["items"] ?? []) as List;
    final deliveryBoy = order['deliveryBoy'];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // -----------------------------------------------------
    // CALCULATE TOTAL AMOUNT
    // -----------------------------------------------------
    double total = 0;
    for (var item in items) {
      double price = (item["price"] ?? 0).toDouble();
      int qty = item["quantity"] ?? 1;
      total += price * qty;
    }
    total += order['tip'] ?? 0;

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: screenHeight * 0.02),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: screenWidth * 0.025,
                offset: Offset(0, screenHeight * 0.005),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- Delivery Boy Card ----------------
                Card(
                  child: ListTile(
                    title: Text(
                      "Delivery Boy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (deliveryBoy != null) ...[
                          Text(
                            deliveryBoy['db_name'] ?? "Unknown",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          Text(
                            deliveryBoy['db_phone'] ?? "No phone",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: screenWidth * 0.038,
                            ),
                          ),
                        ] else ...[
                          Text(
                            "Not Assigned Yet",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: screenWidth * 0.045, color: Colors.green),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          "Delivered",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                // ---------------- Customer Name & Phone ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['username'],
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  order["userphone"],
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.042,
                    color: Colors.black54,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // ---------------- Order Items ----------------
                Text(
                  "Items:",
                  style: GoogleFonts.tinos(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  children: items.map((item) {
                    return Padding(
                      padding:
                          EdgeInsets.only(bottom: screenHeight * 0.008),
                      child: Row(
                        children: [
                          Icon(Icons.circle,
                              size: screenWidth * 0.025, color: Colors.black),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              "${item['dishName']}  x${item['quantity']}",
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.042,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "₹${item['price']}",
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.042,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // ---------------- Ordered Date ----------------
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.04,
                      top: screenHeight * 0.01,
                      bottom: screenHeight * 0.008),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Ordered: ${DateFormat('MMMM d, yyyy – hh:mm a').format((order['createdAt'] as Timestamp).toDate())}",
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.038,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                // ---------------- Tip & Total ----------------
                Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.04, bottom: screenHeight * 0.008),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((order['tip'] ?? 0) > 0)
                        Text(
                          "Tip: ₹${order['tip'].toString()}",
                          style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.038,
                              fontWeight: FontWeight.w600),
                        ),
                      Text(
                        "Total: ₹${total.toStringAsFixed(2)}",
                        style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ],
    );
  },
);


        },
      ),
      
    );
  }
}