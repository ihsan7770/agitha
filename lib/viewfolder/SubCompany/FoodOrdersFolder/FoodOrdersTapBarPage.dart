import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/NewOrdersPage.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/PendingOrdersPage.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/PrevousOrdersPage.dart';
import 'package:flutter/material.dart';

class FoodOrdersTabBarPage extends StatelessWidget {
  const FoodOrdersTabBarPage({super.key});

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
                  "New Orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                child: Text(
                  "Delivery Status",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
              Tab(
                child: Text(
                  "Previous Orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: tabFontSize),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NewOrdersPage(),
            PendingOrdersPage(),
            PreviousOrdersPage(),
          ],
        ),
      ),
    );
  }
}
