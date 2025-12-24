

import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/PreviousUserReservatinons.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/PendingReservationUserPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MyReservationTabBarPage extends StatelessWidget {
  const MyReservationTabBarPage  ({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar( 
         
          bottom: const TabBar(  
            tabs: [
              Tab(text: "Pending Reservations"),
              Tab(text: "Previous Reservations"),
              
              
            ],
          ),
        ),
        body: const TabBarView(
          children: [
               PendingReservationUserDetailsPage(),
          
            PreviousUserReservations()
         

       
          ],
        ),
      ),
    );
  }
} 














