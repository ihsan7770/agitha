import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/BookedEventsPage.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/EventOrderspage.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/PreviousEventsPage.dart';
import 'package:flutter/material.dart';

class UpcomingEventTapBarPage extends StatelessWidget {
  const UpcomingEventTapBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
         
          bottom: const TabBar(
            tabs: [
              Tab(text: "Event Orders"),
              Tab(text: "Booked Events"),
              Tab(text: "Previous Events"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EventOrdersPage(),
            BookedEventsPage(),
            PreviousEventsPage()


            
          ],
        ),
      ),
    );
  }
}