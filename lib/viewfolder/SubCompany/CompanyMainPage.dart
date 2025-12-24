
import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationTabBarPage.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/FoodOrdersTapBarPage.dart';
import 'package:agitha/viewfolder/SubCompany/UpcomingEventFolder/UpcomingEventTapBarPage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanyMainPage extends StatefulWidget {
  const CompanyMainPage({super.key});

  @override
  State<CompanyMainPage> createState() => _CompanyMainPageState();
}

class _CompanyMainPageState extends State<CompanyMainPage> {
    int _currentIndex = 0;

    late final List<Widget> _pages;

    
  @override
  void initState() {
    super.initState();
    _pages = [
       const CompanyHomePage(),
       const ReservationTabBarPage(),
       const FoodOrdersTabBarPage(),
       const UpcomingEventTapBarPage()

       
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
            icon: Icon(Icons.event,size: 25,),
            label: 'Reservations',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining,size: 25,),
            label: 'Orders',
          ),

           BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.champagneGlasses, size: 25,),
            label: 'Events',
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