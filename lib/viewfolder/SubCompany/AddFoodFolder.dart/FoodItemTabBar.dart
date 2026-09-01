import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/BackeryItems.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/CakeItems.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/DrinksItems.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/NormalFoodItems.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/SpecialFoodItems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodItemTabBar extends StatelessWidget {
  const FoodItemTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            labelStyle: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
            ),
            tabs: const [
              Tab(text: "Normal"),
              Tab(text: "Special"),
              Tab(text: "Cake"),
              Tab(text: "Bakery"),
              Tab(text: "Drinks"),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            NormalFoodItems(),
            SpecialFoodItems(),
            CakeItemsPage(),
            BakeryItemsPage(),
            DrinksItemPage(),
          ],
        ),

        // 🔥 Floating Add Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddFoodItem(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}