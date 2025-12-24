import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/PreviousReservationPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationDetailsPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationPaymentDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ReservationTabBarPage extends StatelessWidget {
  const ReservationTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
         
          bottom: const TabBar(
            tabs: [
              Tab(text: "Reservation Orders"),
              Tab(text: "Booked Reservations"),
              Tab(text: "Previous Reservations"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // First Tab
            ReservationDetailsPage(),
         

            // Second Tab
           ReservationPaymentDetails(),

           // Third Tab

           PreviousReservationPage()



          ],
        ),
      ),
    );
  }
}














