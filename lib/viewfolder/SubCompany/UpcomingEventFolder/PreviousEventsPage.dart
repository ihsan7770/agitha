import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/PreviousEventMoreDetails.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/ViewMoreEventDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PreviousEventsPage extends StatefulWidget {
  const PreviousEventsPage({super.key});

  @override
  State<PreviousEventsPage> createState() => _PreviousEventsPageState();
}

class _PreviousEventsPageState extends State<PreviousEventsPage> {


  String getDurationText(int duration) {
    if (duration == 60) return "1 Hour";
    if (duration == 120) return "2 Hours";
    if (duration == 180) return "3 Hours";
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


  @override
  Widget build(BuildContext context) {
     final controller =
        Provider.of<RestaurantEventController>(context,
            listen: false);
    return 
    
    
     Scaffold(
    
      body: StreamBuilder<List<EventModel>>(
        stream: controller.getDateEndedEventStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No previous events found."));
          }

          final events = snapshot.data!;

          return ListView.builder(
  padding: const EdgeInsets.all(10),
  itemCount: events.length,
  itemBuilder: (context, index) {
    final e = events[index];

    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizes
    final titleSize = screenWidth * 0.045;
    final subTitleSize = screenWidth * 0.04;
    final normalTextSize = screenWidth * 0.035;
    final smallTextSize = screenWidth * 0.032;
    final cardPadding = screenWidth * 0.03;

    return Card(
      surfaceTintColor: Colors.white,
      elevation: 4,
      margin: EdgeInsets.only(bottom: screenWidth * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 👤 USER INFO
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                e.userName ?? "Guest",
                style: GoogleFonts.tinos(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.phoneNumber ?? "No phone number",
                    style: GoogleFonts.tinos(
                      fontSize: subTitleSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),

                  if (e.status == "ended")
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PreviousEventMoreDetail(
                              eventId: e.id.toString(),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.01,
                        ),
                        child: Text(
                          "View Bill",
                          style: GoogleFonts.tinos(
                            fontSize: smallTextSize,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            /// EVENT TYPE
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenWidth * 0.01,
              ),
              child: Text(
                e.eventType ?? "",
                style: GoogleFonts.tinos(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// DETAILS
            Text(
              "● Guests: ${e.guests}",
              style: GoogleFonts.tinos(fontSize: normalTextSize),
            ),

            Text(
              "● ${formatTimeRange12Hour(e.time.toDate(), e.duration)}",
              style: GoogleFonts.tinos(fontSize: normalTextSize),
            ),

            Text(
              "● Date: ${e.date.toLocal().toString().split(' ')[0]}",
              style: GoogleFonts.tinos(fontSize: normalTextSize),
            ),

            Text(
              "● ${getDurationText(e.duration)}",
              style: GoogleFonts.tinos(fontSize: normalTextSize),
            ),

            SizedBox(height: screenWidth * 0.02),

            /// STATUS
            Row(
              children: [
                if (e.status == "notReached")
                  Text(
                    "Did not attend",
                    style: GoogleFonts.tinos(
                      fontSize: smallTextSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                const Spacer(),
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