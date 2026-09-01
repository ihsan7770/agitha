import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationBookedDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReservationDetailsPage extends StatefulWidget {
  const ReservationDetailsPage({super.key});

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _TablenoController = TextEditingController();

 

void _showAlertbox(String reservationId) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer<RestaurantReservationController>(
            builder: (context, controller, _) {
              return AlertDialog(
                title: const Text("Enter Table Number"),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _TablenoController,
                    // keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Table Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Table number is required";
                      }
                      // if (int.tryParse(value.trim()) == null) {
                      //   return "Enter a valid number";
                      // }
                      return null;
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: controller.isLoading
                        ? null
                        : () => Navigator.of(dialogContext).pop(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                     backgroundColor:
                       Theme.of(context).colorScheme.primary,
                                                           ),
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            await controller.conformReservation(
                              reservationId,
                              _TablenoController.text.trim(),
                            );

                            _TablenoController.clear();
                            Navigator.of(dialogContext).pop();
                          },
                    child: controller.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Send",style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

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
    final colorScheme = Theme.of(context).colorScheme;

    final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;

    return 
    
    
     Scaffold(
       body: Column(children: [
         Expanded(
           child: StreamBuilder<List<ReservationModel>>(
            stream:RestaurantReservationController(). getRestaurantReservationsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
                  
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading reservations"));
              }
                  
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No new reservations found"));
              }
                  
              final reservations = snapshot.data!;
              
                  
              return 

ListView.builder(
  itemCount: reservations.length,
  itemBuilder: (context, index) {
    final r = reservations[index];

    return Stack(
      children: [
        Card(
          surfaceTintColor: Colors.white,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.01,
          ),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.035),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.userName ?? "Guest",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * 0.006),

                Text(
                  r.phoneNumber ?? "No phone number",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: screenHeight * 0.012),
                const Divider(color: Color.fromARGB(255, 75, 2, 2)),

                SizedBox(height: screenHeight * 0.008),
                Text(
                  "● Number of Guests ${r.guests}",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                  ),
                ),

                SizedBox(height: screenHeight * 0.006),
                Text(
                  "● ${formatTimeRange12Hour(r.time.toDate(), r.duration)}",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                  ),
                ),

                SizedBox(height: screenHeight * 0.006),
                Text(
                  "● Table of ${r.tables.join(', ')} Seats",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                  ),
                ),

                SizedBox(height: screenHeight * 0.006),
                Text(
                  "● ${r.date.toLocal().toString().split(' ')[0]}",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                  ),
                ),

                SizedBox(height: screenHeight * 0.006),
                Text(
                  "● Party of ${r.tables.join(', ')}",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                  ),
                ),

                SizedBox(height: screenHeight * 0.006),
                Text(
                  "● ${getDurationText(r.duration)}",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.035,
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                Row(
                  children: [
                    if (r.status == "pending")
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: colorScheme.primary,
                            width: 1.5,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.012,
                          ),
                        ),
                        onPressed: () async {
                          final confirm = await showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Cancel Reservation"),
                              content: Text(
                                "Are you sure you want to cancel ${r.userName} reservation?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("No"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                     backgroundColor:
                         Theme.of(context).colorScheme.primary,
                         foregroundColor: Colors.white
           
                   ),
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Yes"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await RestaurantReservationController()
                                .cancelReservationRestaurant(r.id.toString());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    "Reservation Cancelled Successfully"),
                                backgroundColor: colorScheme.primary,
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                      ),

                    const Spacer(),

                    StreamBuilder<bool>(
                      stream: RestaurantReservationController()
                          .checkReservationConformedStream(r.id.toString()),
                      builder: (context, snapshot) {
                        final isApproved = snapshot.data ?? false;

                        return ElevatedButton(
                          onPressed: isApproved
                              ? null
                              : () => _showAlertbox(r.id.toString()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isApproved ? Colors.grey : colorScheme.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenWidth * 0.05),
                            ),
                          ),
                          child: Text(
                            isApproved ? "Confirmed" : "Confirm",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: Colors.white,
                            ),
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

        /// 🔴 CANCELLED OVERLAY
        if (r.status == "cancelled")
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 71, 3, 3).withOpacity(0.75),
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "RESERVATION CANCELLED",
                      style: GoogleFonts.tinos(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.01,
                    right: screenWidth * 0.03,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context
                            .read<RestaurantReservationController>()
                            .deleteReservation(r.id.toString());
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
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
           


       ],)



          
          
          
          
          
          
          
          
          
          // 
       
     );
  }
}
