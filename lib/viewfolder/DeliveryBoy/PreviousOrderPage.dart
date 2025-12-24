import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DeliveryBoyPreviousOrdersPage extends StatelessWidget {
  const DeliveryBoyPreviousOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider =
        Provider.of<DeliveryBoyHomeController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
        
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: orderProvider.previousOrdersForDeliveryBoyStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/noorder.png", height: 200),
                  const SizedBox(height: 12),
                  const Text(
                    "No previous deliveries",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final order = orders[index];
              final items =
                  List<Map<String, dynamic>>.from(order["items"] ?? []);

              double total = 0;
              for (var item in items) {
                total += (item["price"] ?? 0) * (item["quantity"] ?? 1);
              }
                total=total+order['tip'];
              return Card(
                surfaceTintColor:Colors.white,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                       title: Text(order['username'] ?? ''),
                       subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(order['userphone'] ?? ''),
                           if ((order['tip'] ?? 0) > 0)
                           Text(  "Given Tip: ${order['tip']}" ,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),

                         ],
                       ),

                        leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade200,
                        child: (order['userimg'] != null &&
                                order['userimg'].toString().isNotEmpty)
                            ? ClipOval(
                                child: Image.network(
                                  order['userimg'],
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 28,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.grey,
                              ),
                      ),


                      ),
                      /// 🔹 Items with price details
                      Column(
                        children: items.map((item) {
                          final double price =
                              (item["price"] ?? 0).toDouble();
                          final int qty = item["quantity"] ?? 1;
                          final double subTotal = price * qty;

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item["dishName"] ?? "Item",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "₹$price",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "Qty: $qty",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                      const Spacer(),
                                    Text(
                                      "Subtotal: ₹$subTotal",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),)
                                  
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 6),

                      /// 🔹 Date
                       Text(
                       "Delivered on ${DateFormat('dd MMM yyyy, hh:mm a').format(
                         (order['createdAt'] as Timestamp).toDate(), // convert Timestamp to DateTime
                       )}",
                       style: const TextStyle(
                         color: Colors.grey,
                         fontSize: 13,
                       ),
                     ),
                         
                      const Divider(height: 20),

                      /// 🔹 Status + Total
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Delivered",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Total: ₹$total",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
