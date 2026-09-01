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
            return const Center(
              child: Text("No pending orders",
                  ),
            );
          }

          return  
          
          ListView.builder(
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
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- Delivery Status Card ----------------
                Card(
                  child: ListTile(
                    title: Text(
                      "Delivery Status",
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
                    trailing: () {
                      final status = order['deliverystatous'];
                      if (status == "accepted_Order") {
                        return Text(
                          "Accepted Order",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.038),
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
                                  content: Text(
                                    order['cancelReason'] ?? "No reason provided",
                                  ),
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
                        return Row(
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
                        );
                      }

                      return Text(
                        "Pending...",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.04,
                        ),
                      );
                    }(),
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
                      padding: EdgeInsets.only(bottom: screenHeight * 0.005),
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

                // ---------------- Tip ----------------
                if ((order['tip'] ?? 0) > 0)
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.03,
                        top: screenHeight * 0.006,
                        bottom: screenHeight * 0.008),
                    child: Row(
                      children: [
                        Text(
                          "Tip:",
                          style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          order['tip'].toString(),
                          style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                // ---------------- Total ----------------
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Total Amount:",
                        style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      Text(
                        "₹${total.toStringAsFixed(2)}",
                        style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
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