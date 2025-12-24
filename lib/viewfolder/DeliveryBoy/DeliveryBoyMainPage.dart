import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyHomePage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoy_RatingReviewPage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/PreviousOrderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryBoyMainPage extends StatefulWidget {
  const DeliveryBoyMainPage({super.key});

  @override
  State<DeliveryBoyMainPage> createState() => _DeliveryBoyMainPageState();
}

class _DeliveryBoyMainPageState extends State<DeliveryBoyMainPage> {
     int _currentIndex = 0;

    late final List<Widget> _pages;

    
  @override
  void initState() {
    super.initState();
    _pages = [
       const DeliverBoyHomePage(),
       const DeliveryBoyPreviousOrdersPage(),
       const DeliveryBoyReviewRatingDetails(),
       const DeliveryBoyProfile(),
       
    ];
  }
  
  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(

       body: _pages[_currentIndex],



          bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(

            icon: Icon(Icons.home,size: 25,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long,size: 25,),
            label: 'Previous Orders',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.reviews_outlined,size: 25,),
            label: 'Rating & Review',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person,size: 25,),
            label: 'profile',
          ),

         

        ],
        currentIndex: _currentIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.black,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );

    




  }
}