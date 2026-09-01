import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/EventPaymentPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationPaymentPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventConformationPage extends StatefulWidget {
  const EventConformationPage({super.key});

  @override
  State<EventConformationPage> createState() =>
      _EventConformationPageState();
}

class _EventConformationPageState extends State<EventConformationPage> {

  String? eventId;
  bool _navigationStarted = false;

  Future<bool> _handleBackPress() async {
    final eventController =
    Provider.of<UserEventProvider>(context, listen: false);


  if (eventId == null) {
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
    final success =
        await eventController.cancelBookedEvent(eventId!);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Booked event cancelled successfully")),
      );
      return true; // allow pop
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to cancel Booked Event")),
      );
      return false; // prevent pop
    }
  }

  return false; // user pressed No
}

  @override
  Widget build(BuildContext context) {

    final eventController = Provider.of<UserEventProvider>(context);

    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:_handleBackPress
          ),
        ),
      
        body:
                 eventController.isLoading
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<EventModel?>(
                stream:
                    eventController.userLatestEventStream(),
              
              
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
      
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text("No Reservation Found"));
                  }
      
                  final events = snapshot.data!;
                  final status = events.status ?? 'pending';
                  eventId = events.id;
      
                  // /// ================= APPROVED =================
                  if (status == 'approved') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                         
                          Navigator.pushReplacement(
                          context,
                            MaterialPageRoute(builder: (context) =>   EventPaymentPage (eventId:eventId, ) ),
                              );
                    });
      
                    return const Center(
                        child: CircularProgressIndicator());
                  }
      
                  /// ================= REJECTED =================
                  if (status == 'rejected') {
      
                     Future.delayed(const Duration(seconds: 2), () async {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const  UserMainPage()));
                       });
                       
                    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 120,
            color:Colors.red.shade700,
          ),
      
          const SizedBox(height: 20),
      
          Text(
            "Warning!",
            style: GoogleFonts.tinos(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
      
          const SizedBox(height: 10),
      
          const Text(
            "The provided information does not match our records.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
      
          const SizedBox(height: 8),
      
          const Text(
            "Please check and try again.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
        ),
      );
      
                  }
      
                  /// ================= PENDING =================
                  return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40), // space from top
      
               Center(
                 child: SizedBox(
                           width: 60,   // 👈 increase size
                           height: 60,
                           child: CircularProgressIndicator(
                             color: Theme.of(context).primaryColor,
                             backgroundColor: Colors.grey.shade300,
                             strokeWidth: 5, // 👈 thicker ring
                           ),
                         ),
               ),
      
          const SizedBox(height: 16),
      
          const Text(
            "Wait few seconds...",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
        ),
      );
      
      
                },
              ),
      ),
    );
  }
}

      
      
