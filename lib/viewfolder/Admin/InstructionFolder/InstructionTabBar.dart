import 'package:agitha/viewfolder/Admin/InstructionFolder/DeliveryBoyInstruction.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/ResturantInstructuions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstructionTabBar extends StatefulWidget {
  const InstructionTabBar({super.key});

  @override
  State<InstructionTabBar> createState() => _InstructionTabBarState();
}

class _InstructionTabBarState extends State<InstructionTabBar> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          
          bottom: const TabBar(
            tabs: [
              Tab(text: "Restaurant Instructions"),
              Tab(text: "Delivery Boy Instructions"),
              
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RestaurantInstructions(),
            DeliveryBoyInstructions()


            
          
          ],
        ),
      ),
    );
  }
}