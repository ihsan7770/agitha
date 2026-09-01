
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedDeliveryBoys.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedRestaurants.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedUsers.dart';
import 'package:flutter/material.dart';

class BlockedAccountTabBar extends StatelessWidget {
  const BlockedAccountTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width;


    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
         
          bottom:  TabBar(
            tabs: [

             Tab(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.008),
        child: Text("Blocked User",style: TextStyle(fontSize: height * 0.034),),
      ),
    ),
    Tab(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.008),
        child: Text("Blocked Restaurant",style: TextStyle(fontSize: height * 0.034)),
      ),
    ),
    Tab(
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.008),
        child: Text("Blocked DeliveryBoys",style: TextStyle(fontSize: height * 0.034)),
      ),
    ),

    
            ],
          ),
        ),
        body: const TabBarView(
          children: [
           AdminBlockedUserDetails(),
           BlockedRestourents(),
           BlockedDeliveryBoys()
        

            
          ],
        ),
      ),
    );
  }
}