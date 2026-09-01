import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/BookedEventsPage.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/EventOrderspage.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/PreviousEventsPage.dart';
import 'package:flutter/material.dart';

class UpcomingEventTapBarPage extends StatelessWidget {
  const UpcomingEventTapBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tabFontSize = screenWidth * 0.035;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Event Orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                child: Text(
                  "Booked Events",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                child: Text(
                  "Previous Events",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EventOrdersPage(),
            BookedEventsPage(),
            PreviousEventsPage(),
          ],
        ),
      ),
    );
  }
}
