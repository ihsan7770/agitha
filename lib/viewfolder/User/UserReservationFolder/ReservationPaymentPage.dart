import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ControllersFolder/UserReservationController.dart';
import 'package:agitha/ModelsFoder/StripePaymentClass.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/UserResrvationDetailsTapBar.dart';
import 'package:agitha/viewfolder/Widgets/PaymentSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';




class ReservationPaymentPage extends StatefulWidget {
  final String? reservationId;
  const ReservationPaymentPage({super.key, this.reservationId});

  @override
  State<ReservationPaymentPage> createState() => _ReservationPaymentPageState();
}

class _ReservationPaymentPageState extends State<ReservationPaymentPage> {


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


Future<bool> _handleBackPress() async {
  final reservationController =
      Provider.of<UserReservationProvider>(context, listen: false);

  if (widget.reservationId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Reservation ID not found")),
    );
    return false; // prevent pop
  }

  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Cancel Reservation"),
      content: const Text(
        "Are you sure you want to cancel this reservation?",
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
        await reservationController.cancelReservation(widget.reservationId.toString());

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reservation cancelled successfully"),
        ),
      );
      return true; // allow pop
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to cancel reservation"),
        ),
      );
      return false; // prevent pop
    }
  }

  return false; // user pressed No
}



  @override
  Widget build(BuildContext context) {
     final reservationController =
        Provider.of<UserReservationProvider>(context);

        // final paymentProvider = Provider.of<PaymentProvider>(context);

     final colorScheme = Theme.of(context).colorScheme;
   final textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:_handleBackPress
            
            
             
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
      
              
         StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
         stream: reservationController.reservationStreamInPaymentPage(widget.reservationId!),
         builder: (context, snapshot) {
       
           // 🔄 Loading
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
           }
       
           // ❌ No data
           if (!snapshot.hasData || !snapshot.data!.exists) {
             return const Center(child: Text("Reservation not found"));
           }
       
           final data = snapshot.data!.data()!;
       
            return 
                 Column(
                   children: [
      
      
                    Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        // 🔴 Top Accent Strip
        Container(
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
        ),
      
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              // 👤 User Name
              Text(
                data["userName"],
                style: GoogleFonts.tinos(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      
              const SizedBox(height: 12),
      
              // 🔹 Number of Guests
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Number of Guests:",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "4",
                    style: GoogleFonts.tinos(fontSize: 16),
                  ),
                ],
              ),
      
              const SizedBox(height: 6),
      
              // 🔹 Booked Hour
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booked Hour:",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                      "${getDurationText(data['duration'])}",
                    style: GoogleFonts.tinos(fontSize: 16),
                  ),
                ],
              ),
      
              const SizedBox(height: 6),
      
              // 🔹 Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date:",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy')
                        .format((data["date"] as Timestamp).toDate()),
                    style: GoogleFonts.tinos(fontSize: 16),
                  ),
                ],
              ),
      
              const SizedBox(height: 6),
      
              // 🔹 Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time:",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                   formatTimeRange12Hour(data['time'].toDate(), data['duration']),
                    style: GoogleFonts.tinos(fontSize: 16),
                  ),
                ],
              ),
      
              const SizedBox(height: 6),
      
              // 🔹 Table No
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Table No:",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    data['tableno'],
                    style: GoogleFonts.tinos(fontSize: 16),
                  ),
                ],
              ),
      
              const SizedBox(height: 12),
      
              Divider(color: Colors.grey.shade300),
      
              const SizedBox(height: 8),
      
              // 💰 Deposit Amount Badge
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Reservation fee: ₹${data['depositAmount']}",
                    style: GoogleFonts.tinos(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
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

      // ✅ Button action
      onPressed: () async {
        // Show Dummy Payment Sheet instead of Stripe
        await showDummyPaymentSheet(
          context,
          data['depositAmount'].toDouble(), // or totalAmount.toDouble()
        );

        // Update payment status after dummy payment
        await reservationController.updatePaymentStatus(widget.reservationId!);

        // Debug info
        debugPrint("Restaurant id: ${data['restaurantId']}");
        debugPrint("Seat list count selected: ${data['tables']}");

        // Navigate to MyReservationTabBarPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MyReservationTabBarPage(),
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


      
      
      
                                  
                      //     Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: SizedBox(
                      //  width: double.infinity,
                      //  child: ElevatedButton(
                      //    style: ElevatedButton.styleFrom(
                      //      backgroundColor: paymentProvider.isLoading
                      //          ? Colors.grey
                      //          : colorScheme.primary,
                      //      shape: RoundedRectangleBorder(
                      //        borderRadius: BorderRadius.circular(10),
                      //      ),
                      //    ),
                     
                      //    // ✅ Disable button when loading
                      //    onPressed: paymentProvider.isLoading
                      //        ? null
                      //        : () async {
      
      
                      //           // //  // // 1️⃣ Start Stripe payment
                      //           //  final paymentSuccess = await  paymentProvider.makePayment(
                      //           //    data['depositAmount'],
                      //           //  );
                     
                      //           // //  2️⃣ Update payment status only if payment success
                      //           //  if (paymentSuccess == true) {
      
                      //              await reservationController
                      //             .updatePaymentStatus(widget.reservationId!);
      
                            
      
      
                      //              debugPrint(" Restourant id: ${data['restaurantId']}");
                      //               debugPrint("Seat list count selected: ${data['tables']}");
      
      
                      //              Navigator.pushReplacement(
                      //               context,
                      //               MaterialPageRoute(
                      //                 builder: (_) =>
                      //                     const MyReservationTabBarPage(),
                      //               ),
                      //             );
                      // // };
                                  
                      //          },
                     
                      //    child:paymentProvider.isLoading
                      //        ? const SizedBox(
                      //            width: 20,
                      //            height: 25,
                      //            child: CircularProgressIndicator(
                      //              color: Colors.white,
                      //              strokeWidth: 2,
                      //            ),
                      //          )
                      //        : Text(
                      //            "Pay Using Stripe",
                      //            style: textTheme.bodyLarge
                      // ?.copyWith(color: Colors.white),
                      //          ),
                      //  ),
                      //   ),
                     
                      // ),
                   ],
                 );
            //  Text("Type: ${data['event']}");
        
         },
       ),
       
       
              
            
            
               
          
          
       
           
          
              
          
                  
          
              
          
            
            ],
          ),
        ),
      ),
    );
  }
}
