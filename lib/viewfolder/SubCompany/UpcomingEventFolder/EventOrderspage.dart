import 'dart:math';

import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/ViewMoreEventDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventOrdersPage extends StatefulWidget {
  const EventOrdersPage({super.key});

  @override
  State<EventOrdersPage> createState() => _EventOrdersPageState();
}

class _EventOrdersPageState extends State<EventOrdersPage> {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: StreamBuilder<List<EventModel>>(
            stream: RestaurantEventController().getRestaurantEventsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text("Error loading events"));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No new events found"));
              }

              final events = snapshot.data!;

              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final e = events[index];

                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;
                  final colorScheme = Theme.of(context).colorScheme;

                  TextStyle infoStyle = GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  );

                  return Stack(
                    children: [
                      Card(
                        surfaceTintColor: Colors.white,
                        margin: EdgeInsets.all(screenWidth * 0.03),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.04),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// USER INFO
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  radius: screenWidth * 0.05,
                                  child: Icon(Icons.person,
                                      size: screenWidth * 0.05),
                                ),
                                title: Text(
                                  e.userName ?? "Guest",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  e.phoneNumber ?? "No phone number",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EventOrderDetailsPage(
                                            eventId: e.id.toString()),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "View More",
                                    style:
                                        TextStyle(fontSize: screenWidth * 0.04),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              /// EVENT TYPE
                              Text(
                                e.eventType ?? "",
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              /// DETAILS
                              Text("● Number of Guests ${e.guests}",
                                  style: infoStyle),
                              Text(
                                "● ${formatTimeRange12Hour(e.time.toDate(), e.duration)}",
                                style: infoStyle,
                              ),
                              Text(
                                "● ${e.date.toLocal().toString().split(' ')[0]}",
                                style: infoStyle,
                              ),
                              Text(
                                "● ${getDurationText(e.duration)}",
                                style: infoStyle,
                              ),
                              Text(
                                "● ${e.decorationType}",
                                style: infoStyle,
                              ),

                              if (e.cakeData != null)
                                Text("● With Cake", style: infoStyle),

                              if (e.eventFoodData != null)
                                Text("● With Food", style: infoStyle),

                              SizedBox(height: screenHeight * 0.015),

                              /// ACTION BUTTONS
                              Row(
                                children: [
                                  if (e.status == "pending")
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: colorScheme.primary,
                                          width: screenWidth * 0.004,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04,
                                          vertical: screenHeight * 0.012,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final confirm = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Cancel Event"),
                                            content: Text(
                                                "Are you sure you want to cancel this ${e.userName} event ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text("No"),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      colorScheme.primary,
                                                ),
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          final messenger =
                                              ScaffoldMessenger.of(context);
                                          await RestaurantEventController()
                                              .cancelEventsRestaurant(
                                                  e.id.toString());
                                          messenger.showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                  "Event Cancelled Successfully"),
                                              backgroundColor:
                                                  colorScheme.primary,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Cancel"),
                                    ),

                                  const Spacer(),

                                  /// CONFIRM BUTTON
                                  StreamBuilder<bool>(
                                    stream: RestaurantEventController()
                                        .checkEventsConformedStream(
                                            e.id.toString()),
                                    builder: (context, snapshot) {
                                      final isApproved = snapshot.data ?? false;

                                      return ElevatedButton(
                                        onPressed: isApproved
                                            ? null
                                            : () async {
                                                await RestaurantEventController()
                                                    .conformEvent(
                                                        e.id.toString());
                                              },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: isApproved
                                              ? Colors.grey
                                              : colorScheme.primary,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.06,
                                            vertical: screenHeight * 0.015,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                screenWidth * 0.06),
                                          ),
                                        ),
                                        child: Text(
                                          isApproved ? "Confirmed" : "Confirm",
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

                      /// CANCEL OVERLAY
                      if (e.status == "cancelled")
                        Positioned(
                          top: screenHeight * 0.01,
                          left: screenWidth * 0.01,
                          right: screenWidth * 0.01,
                          bottom: screenHeight * 0.01,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 71, 3, 3)
                                  .withOpacity(0.75),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.04),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    "EVENT CANCELLED",
                                    style: GoogleFonts.tinos(
                                      fontSize: screenWidth * 0.05,
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
                                    ),
                                    onPressed: () async {
                                      await context
                                          .read<RestaurantEventController>()
                                          .deleteEvents(e.id.toString());
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
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
                    ],
                  );
                },
              );
            },
          ),
        )
      ],
    )

        //

        );
  }
}
