import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ControllersFolder/UserReservationController.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationPaymentPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationsPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReservationConformationPage extends StatefulWidget {
  const ReservationConformationPage({super.key});

  @override
  State<ReservationConformationPage> createState() =>
      _ReservationConformationPageState();
}

class _ReservationConformationPageState
    extends State<ReservationConformationPage> {
  String? reservationId;

  Future<bool> _handleBackPress() async {
  final reservationController =
      Provider.of<UserReservationProvider>(context, listen: false);

  if (reservationId == null) {
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
        await reservationController.cancelReservation(reservationId!);

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

  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return WillPopScope(
    onWillPop:_handleBackPress,
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: 
            _handleBackPress
         
          
        ),
      ),
      body: reservationController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<ReservationModel?>(
              stream: reservationController.userLatestReservationStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
    
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No Reservation Found"));
                }
    
                final reservation = snapshot.data!;
                final status = reservation.status ?? 'pending';
                reservationId = reservation.id;
    
                /// ================= APPROVED =================
                if (status == 'approved') {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReservationPaymentPage(reservationId: reservationId),
                      ),
                    );
                  });
    
                  return const Center(child: CircularProgressIndicator());
                }
    
                /// ================= REJECTED =================
                if (status == 'rejected') {
                  Future.delayed(const Duration(seconds: 2), () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserMainPage()),
                    );
                  });
    
                  return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: screenWidth * 0.30,
                            color: Colors.red.shade700,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            "Warning!",
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Text(
                            "The provided information does not match our records.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            "Please check and try again.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
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
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Center(
                          child: SizedBox(
                            width: screenWidth * 0.15,
                            height: screenWidth * 0.15,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              backgroundColor: Colors.grey.shade300,
                              strokeWidth: screenWidth * 0.01,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          "Wait few seconds...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
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
