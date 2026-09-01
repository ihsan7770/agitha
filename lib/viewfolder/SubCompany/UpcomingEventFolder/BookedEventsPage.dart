import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/EventBillingPage.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/ViewMoreEventDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BookedEventsPage extends StatefulWidget {
  const BookedEventsPage({super.key});

  @override
  State<BookedEventsPage> createState() => _BookedEventsPageState();
}

class _BookedEventsPageState extends State<BookedEventsPage> {
    String getDurationText(int duration) {
      
  if (duration == 60) {
    return "1 Hour";
  } else if (duration == 120) {
    return "2 Hours";
  } else if (duration == 180) {
    return "3 Hours";
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


Widget buildTodayCard(EventModel e) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Card(
  surfaceTintColor: Colors.white,
  margin: EdgeInsets.all(width * 0.025), // responsive margin
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(width * 0.035),
  ),
  child: Padding(
    padding: EdgeInsets.all(width * 0.03),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Header
        ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.005,
          ),

          title: Text(
            e.userName ?? "Guest",
            style: GoogleFonts.tinos(
              fontSize: width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                e.phoneNumber ?? "No phone number",
                style: GoogleFonts.tinos(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EventOrderDetailsPage(eventId: e.id.toString()),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.005),
                  child: Text(
                    "View More",
                    style: GoogleFonts.tinos(
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),

          trailing: e.status != "cancelledAfterPay"
              ? SizedBox(
                  height: height * 0.045,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventBillingPage(
                            eventId: e.id.toString(),
                            eventType: e.eventType,
                            noGuests: e.guests.toString(),
                            amount: e.depositAmount.toString(),
                            decorationType: e.decorationType,
                            bakery: e.bakeryData,
                            cakes: e.cakeData,
                            eventFoodData: e.eventFoodData,
                            docorationsuggestion:
                                e.decorationSuggestion,
                            paidsuggestioncake:
                                e.paidsuggestioncake,
                            cakeDecorationprice:
                                e.cakeDecorationprice,
                            userId: e.userName,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Billing",
                      style: TextStyle(fontSize: width * 0.035),
                    ),
                  ),
                )
              : const SizedBox(),
        ),

        SizedBox(height: height * 0.01),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Text(
            e.eventType ?? "",
            style: GoogleFonts.tinos(
              fontSize: width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        SizedBox(height: height * 0.006),

        Text(
          "● Number of Guests ${e.guests}",
          style: GoogleFonts.tinos(fontSize: width * 0.035),
        ),

        Text(
          "● ${formatTimeRange12Hour(e.time.toDate(), e.duration)}",
          style: GoogleFonts.tinos(fontSize: width * 0.035),
        ),

        Text(
          "● ${e.date.toLocal().toString().split(' ')[0]}",
          style: GoogleFonts.tinos(fontSize: width * 0.035),
        ),

        Text(
          "● ${getDurationText(e.duration)}",
          style: GoogleFonts.tinos(fontSize: width * 0.035),
        ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.02,
            vertical: height * 0.005,
          ),
          child: Text(
            "Decoration Fee: ${e.depositAmount}",
            style: GoogleFonts.tinos(
              fontSize: width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        /// 🔴 Cancelled banner
        if (e.status == "cancelledAfterPay")
          Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(width * 0.025),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFD32F2F).withOpacity(0.85),
                    const Color(0xFFFF5252).withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Event cancelled by the user",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width * 0.032,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        /// 🗑 Remove Button
        if (e.status != "cancelledAfterPay")
          Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: SizedBox(
              height: height * 0.045,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final controller =
                          context.watch<RestaurantEventController>();
                      return AlertDialog(
                        title: const Text("Remove Event"),
                        content: Text(
                            "Are you sure you want to remove this ${e.userName} Event?"),
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
                              await controller
                                  .notReachedEvent(e.id.toString());
                              Navigator.pop(context);
                            },
                            child: controller.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
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
                child: Text(
                  "Remove",
                  style: TextStyle(fontSize: width * 0.035),
                ),
              ),
            ),
          ),
      ],
    ),
  ),
);
}


Widget buildSameCard(EventModel e, BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  final isSmallScreen = width < 360;
  final isTablet = width > 600;

  return Card(
    surfaceTintColor: Colors.white,
    margin: EdgeInsets.all(width * 0.025),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(width * 0.035),
    ),
    child: Padding(
      padding: EdgeInsets.all(width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Header
          ListTile(
            dense: isSmallScreen,
            title: Text(
              e.userName ?? "Guest",
              style: GoogleFonts.tinos(
                fontSize: isTablet
                    ? width * 0.035
                    : isSmallScreen
                        ? width * 0.045
                        : width * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.phoneNumber ?? "No phone number",
                  style: GoogleFonts.tinos(
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventOrderDetailsPage(
                          eventId: e.id.toString(),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.004,
                    ),
                    child: Text(
                      "View More",
                      style: GoogleFonts.tinos(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: height * 0.008),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Text(
              e.eventType ?? "",
              style: GoogleFonts.tinos(
                fontSize: width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: height * 0.006),

          Text(
            "● Number of Guests ${e.guests}",
            style: GoogleFonts.tinos(fontSize: width * 0.035),
          ),

          Text(
            "● ${formatTimeRange12Hour(e.time.toDate(), e.duration)}",
            style: GoogleFonts.tinos(fontSize: width * 0.035),
          ),

          Text(
            "● ${e.date.toLocal().toString().split(' ')[0]}",
            style: GoogleFonts.tinos(fontSize: width * 0.035),
          ),

          Text(
            "● ${getDurationText(e.duration)}",
            style: GoogleFonts.tinos(fontSize: width * 0.035),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.006,
            ),
            child: Text(
              "Decoration Fee: ${e.depositAmount}",
              style: GoogleFonts.tinos(
                fontSize: width * 0.036,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}



Widget buildTodayUI() {
  final controller =
      Provider.of<RestaurantEventController>(context, listen: false);

  return Expanded(
    child: StreamBuilder<List<EventModel>>(
      stream: controller.getPaidEventStream(),
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
          return const Center(child: Text("No booked events today"));
        }

        final events = snapshot.data!;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final e =events[index];

            // 👉 YOUR TODAY CARD UI HERE
            return buildTodayCard(e);
          },
        );
      },
    ),
  );
}


Widget buildTomorrowUI() {
  final controller =
      Provider.of<RestaurantEventController>(context, listen: false);

  return Expanded(
    child: StreamBuilder<List<EventModel>>(
      stream: controller.getTomorrowEventStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading events"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No booked events"));
        }

        final events = snapshot.data!;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final e= events[index];

            // 👉 YOUR TOMORROW CARD UI HERE
            return buildSameCard(e,context);
          },
        );
      },
    ),
  );
}


Widget buildAllUI() {
  final controller =
      Provider.of<RestaurantEventController>(context, listen: false);

  return Expanded(
    child: StreamBuilder<List<EventModel>>(
      stream: controller.getUpcomingEventStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading reservations"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No booked events found"));
        }

        final events = snapshot.data!;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final e = events[index];

            // 👉 YOUR ALL CARD UI HERE
            return buildSameCard(e,context);
          },
        );
      },
    ),
  );
}

Widget dropdownWidget(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  final isSmallScreen = width < 360;
  final isTablet = width > 600;

  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: EdgeInsets.only(
        left: width * 0.06,   // ~25px on normal phones
        top: height * 0.012,
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        isDense: true,
        underline: SizedBox(height: height * 0.01),
        iconSize: width * 0.06,
        style: TextStyle(
          fontSize: isTablet
              ? width * 0.03
              : isSmallScreen
                  ? width * 0.04
                  : width * 0.038,
          color: Colors.black,
        ),
        items: const [
          DropdownMenuItem(value: "Today", child: Text("Today")),
          DropdownMenuItem(value: "Tomorrow", child: Text("Tomorrow")),
          DropdownMenuItem(value: "All", child: Text("All")),
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

Stream<List<EventModel>> getSelectedStream() {
  final controller =
      Provider.of<RestaurantEventController>(context, listen: false);

  switch (selectedValue) {
    case "Today":
      return controller.getPaidEventStream();
    case "Tomorrow":
      return controller.getTomorrowEventStream();
    case "All":
      return controller.getUpcomingEventStream();
    default:
      return controller.getPaidEventStream();
  }
}
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
    body: Column(
      children: [
        dropdownWidget(context),
        Expanded(
          child: StreamBuilder<List<EventModel>>(
            stream: getSelectedStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading events"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No booked events found"));
              }

              final events = snapshot.data!;

              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final e =  events[index];
                  return selectedValue == "Today" ? buildTodayCard(e) : buildSameCard(e,context);
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