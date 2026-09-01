import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PreviousReservationPage extends StatefulWidget {
  const PreviousReservationPage({super.key});

  @override
  State<PreviousReservationPage> createState() =>
      _PreviousReservationPageState();
}

class _PreviousReservationPageState
    extends State<PreviousReservationPage> {

  String getDurationText(int duration) {
    if (duration == 60) return "1 Hour";
    if (duration == 120) return "2 Hours";
    if (duration == 30) return "30 Minutes";
    return "$duration Minutes";
  }

  String formatTimeRange12Hour(DateTime startTime, int durationMinutes) {
    final endTime = startTime.add(Duration(minutes: durationMinutes));

    String format12(DateTime time) {
      int hour = time.hour % 12;
      hour = hour == 0 ? 12 : hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    }

    return "${format12(startTime)} - ${format12(endTime)}";
  }

  double calculateGrandTotal(List<Map<String, dynamic>> foodData) {
    double total = 0;
    for (var food in foodData) {
      final double price = (food['price'] ?? 0).toDouble();
      final int qty = food['qty'] ?? 1;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final controller =
        Provider.of<RestaurantReservationController>(context,
            listen: false);

    return Scaffold(
    
      body: StreamBuilder<List<ReservationModel>>(
        stream: controller.getDateEndedReservationsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No previous reservations"));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final r = reservations[index];

              return
              Card(
  surfaceTintColor: Colors.white,
  elevation: 4,
  margin: EdgeInsets.only(bottom: screenHeight * 0.015),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(screenWidth * 0.03),
  ),
  child: Padding(
    padding: EdgeInsets.all(screenWidth * 0.03),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 👤 USER INFO
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            r.userName ?? "Guest",
            style: GoogleFonts.tinos(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            r.phoneNumber ?? "No phone number",
            style: GoogleFonts.tinos(
              fontSize: screenWidth * 0.038,
              color: Colors.black54,
            ),
          ),
        ),

        const Divider(),

        Text("● Guests: ${r.guests}",
            style: TextStyle(fontSize: screenWidth * 0.038)),
        Text(
          "● ${formatTimeRange12Hour(r.time.toDate(), r.duration)}",
          style: TextStyle(fontSize: screenWidth * 0.038),
        ),
        Text("● Tables: ${r.tables.join(', ')}",
            style: TextStyle(fontSize: screenWidth * 0.038)),
        Text(
          "● Date: ${r.date.toLocal().toString().split(' ')[0]}",
          style: TextStyle(fontSize: screenWidth * 0.038),
        ),
        Text(
          "● ${getDurationText(r.duration)}",
          style: TextStyle(fontSize: screenWidth * 0.038),
        ),

        SizedBox(height: screenHeight * 0.008),

        Row(
          children: [
            if (r.status == "notReached")
              Text(
                "Did not attend",
                style: GoogleFonts.tinos(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                  color: Colors.red,
                ),
              ),
            const Spacer(),
            Text(
              "Table No: ${r.tableno}",
              style: GoogleFonts.tinos(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.015),

        /// 🍽 FOOD ITEMS UI
        if (r.status == "ended")
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              "🍽 Food Items",
              style: GoogleFonts.tinos(
                fontSize: screenWidth * 0.042,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: r.foodData.isEmpty
                ? [
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Text(
                        "No food ordered",
                        style: TextStyle(fontSize: screenWidth * 0.038),
                      ),
                    )
                  ]
                : [
                    Column(
                      children: [

                        /// HEADER ROW
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.008,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Text("Item",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.038))),
                              Expanded(
                                  child: Text("Price",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.038))),
                              Expanded(
                                  child: Text("Qty",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.038))),
                              Expanded(
                                  child: Text("Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.038))),
                            ],
                          ),
                        ),

                        const Divider(),

                        /// FOOD LIST
                        ...r.foodData.map((food) {
                          final String name = food['dish'] ?? '';
                          final double price =
                              (food['price'] ?? 0).toDouble();
                          final int qty = food['qty'] ?? 1;
                          final double itemTotal = price * qty;

                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.005),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(name,
                                        style: TextStyle(
                                            fontSize:
                                                screenWidth * 0.037))),
                                Expanded(
                                    child: Text("₹$price",
                                        style: TextStyle(
                                            fontSize:
                                                screenWidth * 0.037))),
                                Expanded(
                                    child: Text("$qty",
                                        style: TextStyle(
                                            fontSize:
                                                screenWidth * 0.037))),
                                Expanded(
                                  child: Text(
                                    "₹${itemTotal.toStringAsFixed(0)}",
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.038,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        SizedBox(height: screenHeight * 0.01),

                        /// Reservation Fee
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: screenWidth * 0.05),
                            child: Text(
                              "Reservation Fee: ₹${r.depositAmount ?? 0}",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const Divider(),

                        /// GRAND TOTAL
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Grand Total",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹${calculateGrandTotal(r.foodData).toStringAsFixed(0)}",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
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
