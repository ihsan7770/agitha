import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/BookedEventDetailsFolder/UserEventBill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';


class UserPreviousEventsPage extends StatelessWidget {
  const UserPreviousEventsPage({super.key});

  String getDurationText(int duration) {
    if (duration == 60) return "1 Hour";
    if (duration == 120) return "2 Hours";
    if (duration == 180) return "3 Hours";
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
     final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: UserEventProvider().userPasteventStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No previous events found"));
          }

          final events = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final data = events[index];
              // final List foodData = data["foodData"] ?? [];

              DateTime eventTime = (data["time"] as Timestamp).toDate();
                DateTime now = DateTime.now();

                bool isWithin4Hours = now.isAfter(
                    eventTime.subtract(const Duration(hours: 4)),
                  );


              // debugPrint("🍽 Food Data: $foodData");

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
                              width: screenWidth * 0.16,
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
                                    fontSize: screenWidth * 0.07,
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
                             Icon(Icons.circle, size: screenWidth * 0.04, color:  const Color.fromARGB(255, 75, 2, 2)),
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
                             Icon(Icons.circle, size: screenWidth * 0.04, color:  Color.fromARGB(255, 75, 2, 2)),
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
                             Icon(Icons.circle, size: screenWidth * 0.04, color:  const Color.fromARGB(255, 75, 2, 2)),
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
                            Icon(Icons.circle, size: screenWidth * 0.04, color:  Color.fromARGB(255, 75, 2, 2)),
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
                          padding:
                              const EdgeInsets.only( top: 6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: screenWidth * 0.04,
                                    color:  Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                                Text(
                                  "Event Type : ${data["eventType"] ?? "-"}",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
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
                  "Booked event is cancelled by you, half of amount will be refunded",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
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
                  "Booked event is cancelled by you, amount will not be refunded",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:screenWidth * 0.04,
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Booked event cancelled due to non-arrival at the scheduled time",
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.white, // white text
                              ),
                            ),
                          ),
                    ),

                       if(data["status"] == "ended")
                     Align(
                      alignment: Alignment.topRight,
                       child: ElevatedButton(
                             onPressed: () { 
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>  UserEventBillPage(eventId: data['eventId'],)),);
                              
                             },
                             style: ElevatedButton.styleFrom(
                             backgroundColor:
                             Theme.of(context).colorScheme.primary,
                             foregroundColor: Colors.white,
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20),
                             ),
                             ),
                                child: const Text("View Bill"),
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