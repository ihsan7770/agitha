import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ModelsFoder/StripePaymentClass.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/BookedEventDetailsFolder/UserEventTabBar.dart';
import 'package:agitha/viewfolder/Widgets/PaymentSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventPaymentPage extends StatefulWidget {
  final String? eventId;

  const EventPaymentPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventPaymentPage> createState() => _EventPaymentPageState();
}

// ---------------- UTIL FUNCTIONS ----------------

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

// ------------- STATE ----------------

class _EventPaymentPageState extends State<EventPaymentPage> {
  Future<bool> _handleBackPress() async {
    final eventController =
        Provider.of<UserEventProvider>(context, listen: false);

    if (widget.eventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event ID not found")),
      );
      return false;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booked Event"),
        content: const Text(
          "Are you sure you want to cancel this Booked Event?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await eventController.cancelBookedEvent(widget.eventId!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Booked event cancelled successfully")),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to cancel Booked Event")),
        );
        return false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<UserEventProvider>(context);
    // final paymentProvider = Provider.of<PaymentProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back), onPressed: _handleBackPress),
        ),

        // ---------------- BODY ----------------

        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: eventController.eventStreamInPaymentPage(widget.eventId!),
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // No data
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(child: Text("Reservation not found")),
                );
              }

              final data = snapshot.data!.data()!;

              return Column(
                children: [
                  // ================= EVENT CARD =================

                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 243, 7, 7),
                          colorScheme.primary
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /// 🎉 HEADER
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.event,
                                    color: Colors.white, size: 30),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['eventType'],
                                    style: GoogleFonts.tinos(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data["userName"],
                                    style: GoogleFonts.tinos(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        /// 🧾 BODY
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Guests
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Guests",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Text("${data['guests']}",
                                      style: GoogleFonts.tinos(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Duration
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Duration",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Text(getDurationText(data['duration']),
                                      style: GoogleFonts.tinos(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(
                                        (data["date"] as Timestamp).toDate()),
                                    style: GoogleFonts.tinos(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Time
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Time",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Text(
                                    formatTimeRange12Hour(
                                      data['time'].toDate(),
                                      data['duration'],
                                    ),
                                    style: GoogleFonts.tinos(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Decoration
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Decoration",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Flexible(
                                    child: Text(
                                      data['decorationType'],
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.tinos(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Cake",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Flexible(
                                    child: Text(
                                      data['cakeData'] != null &&
                                              (data['cakeData'] as List)
                                                  .isNotEmpty
                                          ? "With Cake"
                                          : "Without Cake",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.tinos(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Food",
                                      style: GoogleFonts.tinos(
                                          fontSize: 15,
                                          color: Colors.grey.shade700)),
                                  Flexible(
                                    child: Text(
                                      data['eventFoodData'] != null &&
                                              (data['eventFoodData'] as List)
                                                  .isNotEmpty
                                          ? "With Food"
                                          : "Without Food",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.tinos(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 30),

                              // Amount
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Amount",
                                    style: GoogleFonts.tinos(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "₹${data['depositAmount']}",
                                    style: GoogleFonts.tinos(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      Padding(
  padding: const EdgeInsets.all(16.0),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () async {
        // ✅ Show Dummy Payment Sheet
        await showDummyPaymentSheet(
          context,
          data['depositAmount'].toDouble(),
        );

                       await eventController
                                    .updatePaymentStatus(widget.eventId!);

        // Optionally, navigate to UserEventTabBar after payment
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UserEventTabBar(),
          ),
        );
      },
      child: Text(
        "Pay Using Stripe",
        style: textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
    ),
  ),
)







                  // ================= PAY BUTTON =================

                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: paymentProvider.isLoading
                  //             ? Colors.grey
                  //             : colorScheme.primary,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //       ),
                  //       onPressed: paymentProvider.isLoading
                  //           ? null
                  //           : () async {
                  //               await eventController
                  //                   .updatePaymentStatus(widget.eventId!);

                  //               Navigator.pushReplacement(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (_) => const UserEventTabBar(),
                  //                 ),
                  //               );
                  //             },
                  //       child: paymentProvider.isLoading
                  //           ? const SizedBox(
                  //               width: 20,
                  //               height: 25,
                  //               child: CircularProgressIndicator(
                  //                 color: Colors.white,
                  //                 strokeWidth: 2,
                  //               ),
                  //             )
                  //           : Text(
                  //               "Pay Using Stripe",
                  //               style: textTheme.bodyLarge
                  //                   ?.copyWith(color: Colors.white),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
