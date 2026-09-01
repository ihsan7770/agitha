import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/AvailableDeliveryBoysPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewOrdersPage extends StatefulWidget {
  const NewOrdersPage({super.key});

  @override
  State<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: context.read<OrderController>().userOrdersStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(
              child: Text("No new orders",
                  ),
            );
          }

          return  ListView.builder(
  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
  itemCount: orders.length,
  itemBuilder: (context, index) {
    final order = orders[index];
    final items = (order["items"] ?? []) as List;

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
        // =====================================================
        // MAIN ORDER CARD
        // =====================================================
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
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CUSTOMER NAME
                Text(
                  order['username'],
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                // CUSTOMER PHONE
                Text(
                  order["userphone"],
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.042,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                // ITEMS
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
                      padding: EdgeInsets.only(bottom: screenHeight * 0.004),
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

                // TIP
                if ((order['tip'] ?? 0) > 0)
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.03,
                        top: screenHeight * 0.003,
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
                          "₹${order['tip']}",
                          style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                // TOTAL PRICE BOX
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

                // ACTION BUTTONS
                Row(
                  children: [
                    if (order['status'] == "pending")
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: colorScheme.primary, width: 1.5),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                            horizontal: screenWidth * 0.05,
                          ),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Cancel Order"),
                                content: Text(
                                    "Are you sure you want to cancel this ${order['username']} order?"),
                                actions: [
                                  TextButton(
                                    child: const Text("No"),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => Navigator.pop(context, true),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirm == true) {
                            final messenger = ScaffoldMessenger.of(context);
                            await context
                                .read<OrderController>()
                                .declineOrder(order['id']);
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text("Order Cancelled Successfully"),
                                backgroundColor: colorScheme.primary,
                              ),
                            );
                          }
                        },
                        child: const Text("Cancel"),
                      ),
                    Spacer(),
                    StreamBuilder<bool>(
                      stream: context
                          .read<OrderController>()
                          .checkOrderConfromedStream(order['id']),
                      builder: (context, snapshot) {
                        final isConfirmed = snapshot.data ?? false;

                        return ElevatedButton(
                          onPressed: isConfirmed
                              ? null
                              : () async {
                                  final messenger = ScaffoldMessenger.of(context);
                                  await context
                                      .read<OrderController>()
                                      .conformOrder(order['id']);
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text("Order Approved Successfully"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isConfirmed ? Colors.grey : colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                              horizontal: screenWidth * 0.05,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.05),
                            ),
                          ),
                          child: Text(
                            isConfirmed ? "Order Confirmed" : "Confirm Order",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // CANCELLED OVERLAY
        if (order['status'] == "cancelled")
          Positioned.fill(
            bottom: screenHeight * 0.02,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 71, 3, 3).withOpacity(0.75),
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "ORDER CANCELLED",
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.02,
                    top: screenHeight * 0.01,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.008,
                          horizontal: screenWidth * 0.03,
                        ),
                      ),
                      onPressed: () async {
                        await context.read<OrderController>().deleteOrder(order['id']);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // PAYMENT OVERLAY
        if (order['paymentStatus'] == "COD" || order['paymentStatus'] == "paid")
          Positioned.fill(
            bottom: screenHeight * 0.02,
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, horizontal: screenWidth * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 3, 233, 11).withOpacity(0.30),
                    Color.fromARGB(255, 3, 233, 11).withOpacity(0.75),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          order['paymentStatus'].toUpperCase(),
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if ((order['tip'] ?? 0) > 0)
                          Text(
                            "Given Tip: ₹${order['tip']}",
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.02,
                    top: screenHeight * 0.01,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.008,
                          horizontal: screenWidth * 0.03,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DeliveryBoyListPage(
                              orderId: order['id'],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        order['deliverystatous'] == "cancelled_Order"
                            ? "Reassign Delivery Boy"
                            : "Assign Delivery Boy",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.038,
                        ),
                      ),
                    ),
                  ),
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
