import 'package:agitha/ControllersFolder/UserReservationController.dart';
import 'package:agitha/viewfolder/Widgets/Sendbill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

class PreviousUserReservations extends StatelessWidget {
  const PreviousUserReservations({super.key});

  String getDurationText(int duration) {
    if (duration == 60) return "1 Hour";
    if (duration == 120) return "2 Hours";
    if (duration == 30) return "30 Minutes";
    return "$duration Minutes";
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

  String formatTimeRange(DateTime start, int durationMinutes) {
    final end = start.add(Duration(minutes: durationMinutes));
    final startStr = DateFormat("hh:mm a").format(start);
    final endStr = DateFormat("hh:mm a").format(end);
    return "$startStr - $endStr";
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: UserReservationProvider().userPastReservationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No previous reservations found"));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final data = reservations[index];
              final List foodData = data["foodData"] ?? [];

              DateTime reservationTime = (data["time"] as Timestamp).toDate();
                DateTime now = DateTime.now();

                bool isWithin4Hours = now.isAfter(
                    reservationTime.subtract(const Duration(hours: 4)),
                  );


              debugPrint("🍽 Food Data: $foodData");

              return Card(
                surfaceTintColor: Colors.white,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ---------- HEADER ----------
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              data["image"] ?? "",
                              width:screenWidth * 0.16,
                              height: screenWidth * 0.16,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image, size: 60),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["restaurantName"] ?? "",
                                  style: GoogleFonts.tinos(
                                    fontSize:screenWidth * 0.065,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data["location"] ?? "",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.05,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// ---------- DETAILS ----------
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                             Icon(Icons.circle, size: screenWidth * 0.04, color: Color.fromARGB(255, 75, 2, 2)),
                            const SizedBox(width: 6),
                            Text(
                              "Guests : ${data["guests"] ?? "-"}",
                              style: GoogleFonts.tinos(fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                             Icon(Icons.circle, size: screenWidth * 0.04, color: Color.fromARGB(255, 75, 2, 2)),
                            const SizedBox(width: 6),
                            Text(
                              "Date : ${
                                data["date"] is Timestamp
                                  ? DateFormat('dd MMM yyyy')
                                      .format((data["date"] as Timestamp).toDate().toLocal())
                                  : "-"
                              }",
                              style: GoogleFonts.tinos(fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                           Icon(Icons.circle, size: screenWidth * 0.04, color: Color.fromARGB(255, 75, 2, 2)),
                            const SizedBox(width: 6),
                            Text(
                              "Duration : ${getDurationText(data["duration"] ?? 0)}",
                              style: GoogleFonts.tinos(fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                             Icon(Icons.circle, size: screenWidth * 0.04, color: Color.fromARGB(255, 75, 2, 2)),
                            const SizedBox(width: 6),
                            Text(
                              "Time : ${
                                data["time"] is Timestamp
                                  ? formatTimeRange(
                                      (data["time"] as Timestamp).toDate().toLocal(),
                                      data["duration"] ?? 60,
                                    )
                                  : "-"
                              }",
                              style: GoogleFonts.tinos(fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                             Icon(Icons.circle, size: screenWidth * 0.04, color: Color.fromARGB(255, 75, 2, 2)),
                            const SizedBox(width: 6),
                            Text(
                              "Table Type : ${
                                (data["tables"] != null)
                                  ? "${(data["tables"] as List).join(', ')} seats"
                                  : "-"
                              }",
                              style: GoogleFonts.tinos(fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                             Icon(Icons.circle, size: screenWidth * 0.04, color: Color.fromARGB(255, 75, 2, 2)),
                            const SizedBox(width: 6),
                            Text(
                              "Table No : ${data["tableno"] ?? "-"}",
                              style: GoogleFonts.tinos(fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),

                    

                      const SizedBox(height: 12),

                      /// ---------- FOOD BILL ----------
                      /// 
                      /// 
                      /// 
    if (data["status"] == "cancelledAfterPay")
      isWithin4Hours
          ? SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                     Color.fromARGB(255, 148, 3, 3).withOpacity(0.85),
                      const Color(0xFFFF5252).withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child:  Text(
                  "Reservation cancelled by you, half of amount will be refunded",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                   gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 148, 3, 3).withOpacity(0.85),
                      const Color(0xFFFF5252).withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child:  Text(
                  "Reservation cancelled by you, amount will not be refunded",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    
    
                          if(data["status"] == "notReached")
    
                         Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFD32F2F), // dark red
                                Color(0xFFFF5252), // light red
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8), // optional rounded corners
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Reservation cancelled due to non-arrival at the scheduled time",
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // white text
                              ),
                            ),
                          ),
                    ),

                      
                      if(data["status"] == "ended")

                      Theme(
  data: Theme.of(context).copyWith(
    dividerColor: Colors.transparent,
  ),
  child: Builder(
    builder: (context) {
      // MediaQuery for responsive layout
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        title: Text(
          "🍽 Bill Details",
          style: TextStyle(
            fontSize: screenWidth * 0.05, // responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
        children: foodData.isEmpty
            ? [
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: const Text("No food ordered"),
                )
              ]
            : [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.01,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Item",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Price",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Qty",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Total",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(thickness: 1, color: Colors.grey[300]),

                    ...foodData.map((food) {
                      final String name = food['dish'] ?? '';
                      final double price = (food['price'] ?? 0).toDouble();
                      final int qty = food['qty'] ?? 1;
                      final double itemTotal = price * qty;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.005,
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(name, style: TextStyle(fontSize: screenWidth * 0.04))),
                            Expanded(child: Text("₹$price", style: TextStyle(fontSize: screenWidth * 0.04))),
                            Expanded(child: Text("  $qty", style: TextStyle(fontSize: screenWidth * 0.04))),
                            Expanded(
                              child: Text(
                                "₹${itemTotal.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.002,
                        right: screenWidth * 0.07,
                        top: screenHeight * 0.01,
                        bottom: screenHeight * 0.01,
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Reservation Fee: ₹${data["depositAmount"] ?? 0}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.042,
                          ),
                        ),
                      ),
                    ),

                    Divider(thickness: 1, color: Colors.grey[300]),

                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.025),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Grand Total",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
                          ),
                          Text(
                            "₹${calculateGrandTotal(foodData.cast<Map<String, dynamic>>()).toStringAsFixed(0)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(thickness: 1, color: Colors.grey[300]),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: screenWidth * 0.03,
                          bottom: screenHeight * 0.01,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            debugPrint("⬇️ Download Bill button clicked");

                            try {
                              final file = await generateBillPdfFromFoodData(
                                foodData: foodData.cast<Map<String, dynamic>>(),
                                restaurantName: data["restaurantName"] ?? "NA",
                                reservationId: data["reservationId"] ?? "NA",
                                reservationFee: data["depositAmount"]?.toString() ?? "00",
                              );

                              await OpenFilex.open(file.path);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("✅ Bill downloaded successfully")),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("❌ Failed to download bill: $e")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            ),
                          ),
                          child: Text(
                            "Download Bill",
                            style: TextStyle(fontSize: screenWidth * 0.045),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
      );
    },
  ),




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
