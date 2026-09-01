import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationBillingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookedReservationDetails extends StatefulWidget {
   BookedReservationDetails({super.key});

  @override
  State<BookedReservationDetails> createState() => _BookedReservationDetailsState();
}

class _BookedReservationDetailsState extends State<BookedReservationDetails> {
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

// widget


Widget buildTodayCard(ReservationModel r) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final isSmallScreen = screenWidth < 360;

  return Card(
    surfaceTintColor: Colors.white,
    margin: EdgeInsets.all(screenWidth * 0.025),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),

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
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),

            trailing: r.status != "cancelledAfterPay"
                ? SizedBox(
                    width: isSmallScreen ? screenWidth * 0.28 : screenWidth * 0.22,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationBillPage(
                              reservationId: r.id.toString(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.012,
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:  Text("Billing" ,style: TextStyle(fontSize: screenWidth * 0.03),),
                    ),
                  )
                : const SizedBox(),
          ),

          const Divider(color: Color.fromARGB(255, 75, 2, 2)),

          /// 🔹 Details
          Text(
            "● Number of Guests ${r.guests}",
            style: GoogleFonts.tinos(fontSize: screenWidth * 0.038),
          ),
          Text(
            "● ${formatTimeRange12Hour(r.time.toDate(), r.duration)}",
            style: GoogleFonts.tinos(fontSize: screenWidth * 0.038),
          ),
          Text(
            "● Table of ${r.tables.join(', ')} Seats",
            style: GoogleFonts.tinos(fontSize: screenWidth * 0.038),
          ),
          Text(
            "● ${r.date.toLocal().toString().split(' ')[0]}",
            style: GoogleFonts.tinos(fontSize: screenWidth * 0.038),
          ),
          Text(
            "● ${getDurationText(r.duration)}",
            style: GoogleFonts.tinos(fontSize: screenWidth * 0.038),
          ),

          SizedBox(height: screenHeight * 0.01),

          /// 🔹 Fee + Table No
          Row(
            children: [
              Text(
                "Reservation Fee: ${r.depositAmount}",
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                "Table No: ${r.tableno}",
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          /// 🔴 Cancelled Banner
          if (r.status == "cancelledAfterPay")
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.015),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD32F2F).withOpacity(0.85),
                    const Color(0xFFFF5252).withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: const Text(
                "Reservation cancelled by the user",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),

          /// ❌ Remove Button
          if (r.status != "cancelledAfterPay")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: screenWidth * 0.30,
                child: 
                
                ElevatedButton(


                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final controller =
                            context.watch<RestaurantReservationController>();
                        return AlertDialog(
                          title: const Text("Remove reservation"),
                          content: Text(
                            "Are you sure you want to remove ${r.userName} reservation?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white
                              ),
                              onPressed: () async {
                                await controller.notReachedReservation(
                                  r.id.toString(),
                                );
                                Navigator.pop(context);
                              },
                              child: controller.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child:  Text("Remove",style: TextStyle(fontSize: screenWidth * 0.03),),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}






Widget buildSameCard(BuildContext context, ReservationModel r) {
  final screenWidth = MediaQuery.of(context).size.width;
  final baseFont = screenWidth * 0.04;

  return Card(
    surfaceTintColor: Colors.white,
    margin: const EdgeInsets.all(10),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Header
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(
              r.userName ?? "Guest",
              style: GoogleFonts.tinos(
                fontSize: baseFont + 2,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              r.phoneNumber ?? "No phone number",
              style: GoogleFonts.tinos(
                fontSize: baseFont,
                color: Colors.black54,
              ),
            ),
          ),

          const Divider(color: Color.fromARGB(255, 75, 2, 2)),

          /// 🔹 Details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              "● Number of Guests: ${r.guests}",
              style: GoogleFonts.tinos(fontSize: baseFont),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              "● ${formatTimeRange12Hour(r.time.toDate(), r.duration)}",
              style: GoogleFonts.tinos(fontSize: baseFont),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              "● Table of ${r.tables.join(', ')} Seats",
              style: GoogleFonts.tinos(fontSize: baseFont),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              "● ${r.date.toLocal().toString().split(' ')[0]}",
              style: GoogleFonts.tinos(fontSize: baseFont),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              "● ${getDurationText(r.duration)}",
              style: GoogleFonts.tinos(fontSize: baseFont),
            ),
          ),

          const SizedBox(height: 8),

          /// 🔹 Footer
          Row(
            children: [
              Flexible(
                child: Text(
                  "Reservation Fee: ₹${r.depositAmount}",
                  style: GoogleFonts.tinos(
                    fontSize: baseFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                "Table No: ${r.tableno}",
                style: GoogleFonts.tinos(
                  fontSize: baseFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}






Widget buildTodayUI() {
  final controller =
      Provider.of<RestaurantReservationController>(context, listen: false);

  return Expanded(
    child: StreamBuilder<List<ReservationModel>>(
      stream: controller.getPaidReservationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

       if (snapshot.hasError) {
  return Center(
    child: Text(
      "Error: ${snapshot.error}",
      style: const TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    ),
  );
}


        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reservations today"));
        }

        final reservations = snapshot.data!;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final r = reservations[index];

            // 👉 YOUR TODAY CARD UI HERE
            return buildTodayCard(r);
          },
        );
      },
    ),
  );
}


Widget buildTomorrowUI() {
  final controller =
      Provider.of<RestaurantReservationController>(context, listen: false);

  return Expanded(
    child: StreamBuilder<List<ReservationModel>>(
      stream: controller.getTomorrowReservationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading reservations"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reservations tomorrow"));
        }

        final reservations = snapshot.data!;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final r = reservations[index];

            // 👉 YOUR TOMORROW CARD UI HERE
            return buildSameCard(context,r);
          },
        );
      },
    ),
  );
}


Widget buildAllUI() {
  final controller =
      Provider.of<RestaurantReservationController>(context, listen: false);

  return Expanded(
    child: StreamBuilder<List<ReservationModel>>(
      stream: controller.getUpcomingReservationsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading reservations"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reservations found"));
        }

        final reservations = snapshot.data!;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final r = reservations[index];

            // 👉 YOUR ALL CARD UI HERE
            return buildSameCard(context,r);
          },
        );
      },
    ),
  );
}


Widget dropdownWidget() {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  final isSmallScreen = screenWidth < 360;

  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.06,   // responsive left padding
        top: screenHeight * 0.015,  // responsive top padding
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        underline: SizedBox(height: screenHeight * 0.01),
        iconSize: screenWidth * 0.06,
        style: TextStyle(
          fontSize: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.045,
          color: Colors.black,
        ),
        items: const [
          DropdownMenuItem(
            value: "Today",
            child: Text("Today"),
          ),
          DropdownMenuItem(
            value: "Tomorrow",
            child: Text("Tomorrow"),
          ),
          DropdownMenuItem(
            value: "All",
            child: Text("All"),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            selectedValue = value;
          });
        },
      ),
    ),
  );
}








String selectedValue = "Today";

Stream<List<ReservationModel>> getSelectedStream() {
  final controller =
      Provider.of<RestaurantReservationController>(context, listen: false);

  switch (selectedValue) {
    case "Today":
      return controller.getPaidReservationsStream();
    case "Tomorrow":
      return controller.getTomorrowReservationsStream();
    case "All":
      return controller.getUpcomingReservationsStream();
    default:
      return controller.getPaidReservationsStream();
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        dropdownWidget(),
        Expanded(
          child: StreamBuilder<List<ReservationModel>>(
            stream: getSelectedStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading reservations"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No booked reservations found"));
              }

              final reservations = snapshot.data!;

              return ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  final r = reservations[index];
                  return selectedValue == "Today" ? buildTodayCard(r) : buildSameCard(context,r);
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
    
     
  }
