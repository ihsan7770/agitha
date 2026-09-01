import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ControllersFolder/UserReservationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingReservationUserDetailsPage extends StatelessWidget {
  const PendingReservationUserDetailsPage({super.key});

   String getDurationText(int duration) {
  if (duration == 60) {
    return "1 Hour";
  } else if (duration == 120) {
    return "2 Hours";
  } else if (duration == 30) {
    return "30 Minutes";
  } else {
    return "$duration Minutes";
  }
}



String formatTimeRange12Hour(DateTime startTime, int durationMinutes) {
  final endTime = startTime.add(Duration(minutes: durationMinutes));

  String format12(DateTime time) {
    int hour = time.hour % 12;
    hour = hour == 0 ? 12 : hour; // handle 12 AM / 12 PM
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  return "${format12(startTime)} - ${format12(endTime)}";
}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: UserReservationProvider().userReservationWithCompanyStream(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reservations found"));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final data = reservations[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                
                        /// ---------- Header ----------
                 ListTile(
  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

  leading: ClipRRect(
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

  title: Text(
    data["restaurantName"] ?? "",
    style: GoogleFonts.tinos(
      fontSize: screenWidth * 0.06,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 75, 2, 2),
    ),
  ),

  subtitle: Text(
    data["location"] ?? "",
    style: GoogleFonts.tinos(
      fontSize: screenWidth * 0.04,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  ),

  trailing: InkWell(
  onTap: () {
    showDialog(
  context: context,
  barrierDismissible: false,
  builder: (dialogContext) => AlertDialog(
    title: const Text("Cancel Reservation"),
    content: const Text("Are you sure you want to Cancel Reservation ?"),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(dialogContext); // close dialog
        },
        child: const Text("No"),
      ),

   Consumer<UserReservationProvider>(
  builder: (context, provider, _) {
    return ElevatedButton( style: ElevatedButton.styleFrom( 
      backgroundColor: provider.isLoading ? Colors.grey
       : Theme.of(context).colorScheme.primary, ), onPressed: provider.isLoading ? null 
       : () async { debugPrint("reservationid............:${data["reservationId"]}"); 
       await provider.cancelReservationAfterPay( data["reservationId"].toString(), ); 
       Navigator.pop(dialogContext); }, child: provider.isLoading ? 
       SizedBox( width: screenWidth * 0.06, height: screenWidth * 0.06, 
       child: CircularProgressIndicator( color: Colors.white, strokeWidth: 2, ), ) : 
    const Text( "Yes", style: TextStyle(color: Colors.white), ), );

  },
),

    ],
  ),
);




    // TODO: button action
  },
  borderRadius: BorderRadius.circular(10),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(10),
    ),
    child: const Text(
      "Cancel",
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),

),

                
                        const SizedBox(height: 15),
                
                        /// ---------- Booked Details ----------
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "Booked Details",
                              style: GoogleFonts.tinos(
                                fontSize:  screenWidth * 0.06,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                
                        const SizedBox(height: 10),
                
                        /// Guests
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                 Icon(Icons.circle,
                                    size: screenWidth * 0.04,
                                    color: Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                                Text(
                                  "Guests : ${data["guests"] ?? "-"}",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                
                        /// Date
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                 Icon(Icons.circle,
                                    size: screenWidth * 0.04,
                                    color: Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                                Text(
                  "Date : ${data["date"] != null && data["date"] is Timestamp ? DateFormat('EEEE, MMM dd, yyyy').format((data["date"] as Timestamp).toDate().toLocal()) : '-'}",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                
                              ],
                            ),
                          ),
                        ),
                
                
                            /// Time
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                 Icon(Icons.circle,
                                    size: screenWidth * 0.04,
                                    color: Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                                Text(
                                  "Duration : ${getDurationText(data["duration"])}",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                
                        /// Time
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                 Icon(Icons.circle,
                                    size:  screenWidth * 0.04,
                                    color: Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                       Text(
                       "Time : ${data["time"] != null && data["time"] is Timestamp
                           ? (() {
                               // Start time
                               final start = (data["time"] as Timestamp).toDate().toLocal();
                     
                               // Duration in minutes (make sure you store it in Firestore)
                               final durationMinutes = data["duration"] ?? 30; // default 60
                     
                               // End time
                               final end = start.add(Duration(minutes: durationMinutes));
                     
                               // Format
                               final startStr = DateFormat("hh:mm a").format(start);
                               final endStr = DateFormat("hh:mm a").format(end);
                     
                               return "$startStr to $endStr";
                             })()
                           : "-"}",
                       style: GoogleFonts.tinos(
                         fontSize:  screenWidth * 0.05,
                         fontWeight: FontWeight.w400,
                       ),
                     ),
                
                   ],
                            ),
                          ),
                        ),
                
                         Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                 Icon(Icons.circle,
                                    size:  screenWidth * 0.04,
                                    color: Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                                Text(
                                  "Table Type : ${data["tables"].join(' seats, ') ?? "-"} seats",
                                  style: GoogleFonts.tinos(
                                    fontSize:  screenWidth * 0.05,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                
                        /// Table Number
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 6),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                 Icon(Icons.circle,
                                    size:  screenWidth * 0.04,
                                    color: Color.fromARGB(255, 75, 2, 2)),
                                const SizedBox(width: 6),
                                Text(
                                  "Table No : ${data["tableno"] ?? "-"}",
                                  style: GoogleFonts.tinos(
                                    fontSize:  screenWidth * 0.05,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                      "Reservation fee : ${data["depositAmount"] ?? "-"}",
                                      style: GoogleFonts.tinos(
                                        fontSize:  screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                          ),
                        ),
                           const SizedBox(height: 12),
                      ],
                    ),
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
