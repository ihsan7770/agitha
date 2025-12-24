
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedDeliveryBoys.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedRestaurants.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedUsers.dart';
import 'package:flutter/material.dart';

class BlockedAccountTabBar extends StatelessWidget {
  const BlockedAccountTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
         
          bottom: const TabBar(
            tabs: [
              Tab(text: "Blocked User"),
              Tab(text: "Blocked Restaurant"),
              Tab(text: "Blocked DeliveryBoys"),
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