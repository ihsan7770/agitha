import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/PreviousEventsPage.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/BookedEventDetailsFolder/PendingEventsPage.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/BookedEventDetailsFolder/PreviousEventsPage.dart';
import 'package:flutter/material.dart';

class UserEventTabBar extends StatelessWidget {
  const UserEventTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar( 
         
          bottom: const TabBar(  
            tabs: [
              Tab(text: "Pending Event Bookings"),
              Tab(text: "Previous Event Bookings"),
              
              
            ],
          ),
        ),
        body: const TabBarView(
          children: [
          //   // First Tab
          UserPendingEventsPage(),
         

          //   // Second Tab
          UserPreviousEventsPage()
          ],
        ),
      ),
    );
  }
}