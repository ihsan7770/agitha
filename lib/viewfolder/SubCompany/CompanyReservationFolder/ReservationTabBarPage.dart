import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/PreviousReservationPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationDetailsPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationBookedDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ReservationTabBarPage extends StatelessWidget {
  const ReservationTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabFontSize = screenWidth * 0.035;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
         
          bottom:  TabBar(
            tabs: [

              Tab(

      child: Text(
        "Reservation Orders",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: tabFontSize),
      ),
    ),

    Tab(
      child: Text(
        "Booked Reservations",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: tabFontSize),
      ),
    ),

    Tab(
      child: Text(
        "Previous Reservations",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: tabFontSize),
      ),
    ),
    

            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First Tab
            ReservationDetailsPage(),
         

            // Second Tab
          BookedReservationDetails(),

           // Third Tab

           PreviousReservationPage()



          ],
        ),
      ),
    );
  }
}














