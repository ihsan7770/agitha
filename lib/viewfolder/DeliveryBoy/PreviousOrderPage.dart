import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DeliveryBoyPreviousOrdersPage extends StatelessWidget {
  const DeliveryBoyPreviousOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
final double w = size.width;
final double h = size.height;

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

          return  ListView.builder(
  itemCount: orders.length,
  padding: EdgeInsets.all(w * 0.03),
  itemBuilder: (context, index) {
    final order = orders[index];
    final items =
        List<Map<String, dynamic>>.from(order["items"] ?? []);

    double total = 0;
    for (var item in items) {
      total += (item["price"] ?? 0) * (item["quantity"] ?? 1);
    }
    total += (order['tip'] ?? 0);

    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      margin: EdgeInsets.only(bottom: h * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.04),
      ),
      child: Padding(
        padding: EdgeInsets.all(w * 0.035),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 USER INFO
            ListTile(
              title: Text(
                order['username'] ?? '',
                style: TextStyle(fontSize: w * 0.045),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['userphone'] ?? '',
                    style: TextStyle(fontSize: w * 0.035),
                  ),
                  if ((order['tip'] ?? 0) > 0)
                    Text(
                      "Given Tip: ${order['tip']}",
                      style: TextStyle(
                        fontSize: w * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              leading: CircleAvatar(
                radius: w * 0.055,
                backgroundColor: Colors.grey.shade200,
                child: (order['userimg'] != null &&
                        order['userimg'].toString().isNotEmpty)
                    ? ClipOval(
                        child: Image.network(
                          order['userimg'],
                          width: w * 0.11,
                          height: w * 0.11,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Icon(
                              Icons.person,
                              size: w * 0.07,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: w * 0.07,
                        color: Colors.grey,
                      ),
              ),
            ),

            /// 🔹 ITEMS
            Column(
              children: items.map((item) {
                final double price =
                    (item["price"] ?? 0).toDouble();
                final int qty = item["quantity"] ?? 1;
                final double subTotal = price * qty;

                return Container(
                  margin: EdgeInsets.only(bottom: h * 0.012),
                  padding: EdgeInsets.all(w * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(w * 0.03),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item["dishName"] ?? "Item",
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            "₹$price",
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.005),
                      Row(
                        children: [
                          Text(
                            "Qty: $qty",
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Subtotal: ₹$subTotal",
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: h * 0.01),

            /// 🔹 DATE
            Text(
              "Delivered on ${DateFormat('dd MMM yyyy, hh:mm a').format(
                (order['createdAt'] as Timestamp).toDate(),
              )}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: w * 0.035,
              ),
            ),

            Divider(height: h * 0.03),

            /// 🔹 STATUS + TOTAL
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: w * 0.05,
                ),
                SizedBox(width: w * 0.015),
                Text(
                  "Delivered",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.04,
                  ),
                ),
                const Spacer(),
                Text(
                  "Total: ₹$total",
                  style: TextStyle(
                    fontSize: w * 0.045,
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
