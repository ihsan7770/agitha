import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/NormalFoodItems.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/SpecialFoodItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodItemTabBar extends StatelessWidget {
  const FoodItemTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
      
          
          bottom: const TabBar(
            tabs: [
              Tab(text: "Normal Dishes"),
              Tab(text: "Special Dishes"),
              
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            NormalFoodItems (),
            SpecialFoodItems()

           
          ],
        ),
      ),
    );
  }
}