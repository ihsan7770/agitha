import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/AvailableDeliveryBoysPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/NewOrdersPage.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/PendingOrdersPage.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/PrevousOrdersPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodOrdersTabBarPage extends StatefulWidget {
  const FoodOrdersTabBarPage({super.key});

  @override
  State<FoodOrdersTabBarPage> createState() => _FoodOrdersPageState();
}

class _FoodOrdersPageState extends State<FoodOrdersTabBarPage> {
  

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
       automaticallyImplyLeading: false,
          
          bottom: const TabBar(
            tabs: [
              Tab(text: "New Orders"),
              Tab(text: "Delivery Statous"),
              Tab(text: "Previous Orders",)
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            
            NewOrdersPage (),

            //Second Tab  Pending Orders Page
            PendingOrdersPage(),

           
            //third
            PreviousOrdersPage()
          ],
        ),
      ),
    );
  }
}
