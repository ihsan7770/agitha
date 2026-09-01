import 'package:agitha/ControllersFolder/InternetClass.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/viewfolder/User/CareersFolder/Careers.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/Media.dart';
import 'package:agitha/viewfolder/User/NoInternet.dart';
import 'package:agitha/viewfolder/User/SubscribtionPage.dart';
import 'package:agitha/viewfolder/User/UserBlockPage.dart';
import 'package:agitha/viewfolder/User/UserHomePage.dart';
import 'package:agitha/viewfolder/Widgets/Carousel_Slider.dart';
import 'package:agitha/viewfolder/Widgets/Drawer.dart';
import 'package:agitha/viewfolder/Widgets/International_GridView.dart';
import 'package:agitha/viewfolder/Widgets/Local_GridView.dart';
import 'package:agitha/viewfolder/Widgets/animateditembar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserMainPage extends StatefulWidget {
  const UserMainPage({super.key});

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  int _currentIndex = 0;

  // List of pages to show when bottom nav is tapped
  late final List<Widget> _pages;


  @override
  void initState() {
    super.initState();
    _pages = [
      const UserHomePage() , // Home content as a separate method
      const CareersPage(),
      const MediaPage(),
      const SubscribtionPage()
    ];
  }

  // Extracted home content to avoid recursion
@override
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  final userProvider =
      Provider.of<UserRegistrationProvider>(context, listen: false);

  return StreamBuilder<bool>(
    stream: NetworkService.internetStatusStream,
    initialData: true,
    builder: (context, netSnapshot) {
      final hasInternet = netSnapshot.data ?? true;

      // // ❌ NO INTERNET
      // if (!hasInternet) {
      //   return const NoInternetPage();
      // }

      // ✅ INTERNET OK → CHECK BLOCK STATUS
      return StreamBuilder<bool>(
        stream: userProvider.blockedStatusStream(),
        initialData: false,
        builder: (context, snapshot) {
          final isBlocked = snapshot.data ?? false;

          if (isBlocked) {
            return const UserBlockPage();
          }

          // ✅ NORMAL UI
          return Scaffold(
            appBar: AppBar(
              
            actions: [

    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton.icon(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginPage(),
            ),
          );
        },
        icon: const Icon(Icons.power_settings_new),
        label: const Text("Login"),
      ),
    ),
],
            ),
            drawer: const CustomDrawer(),
            body: Stack(
              children: [
                _pages[_currentIndex],
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BottomCartBar(
                    onViewCart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodCartPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
               type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Colors.black,
            
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.work), label: 'Careers'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.photo), label: 'Media'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Subscription'),
              ],
            ),
          );
        },
      );
    },
  );
}

}
