import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/viewfolder/User/CareersFolder/Careers.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/Media.dart';
import 'package:agitha/viewfolder/User/SubscribtionPage.dart';
import 'package:agitha/viewfolder/User/UserBlockPage.dart';
import 'package:agitha/viewfolder/Widgets/Carousel_Slider.dart';
import 'package:agitha/viewfolder/Widgets/Drawer.dart';
import 'package:agitha/viewfolder/Widgets/International_GridView.dart';
import 'package:agitha/viewfolder/Widgets/Local_GridView.dart';
import 'package:agitha/viewfolder/Widgets/animateditembar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List of pages to show when bottom nav is tapped
  late final List<Widget> _pages;


  @override
  void initState() {
    super.initState();
    _pages = [
      _homeContent(),  // Home content as a separate method
      const CareersPage(),
      const MediaPage(),
      const SubscribtionPage()
    ];
  }

  // Extracted home content to avoid recursion
 static Widget _homeContent() {
  return Scaffold(
    body: LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final baseFontSize = screenWidth * 0.045; // Responsive scaling factor
    
        return SingleChildScrollView(
          child: Column(
            children: [
              const CarouselImageSlider(),
              const SizedBox(height: 20),
    
              // Section: International Brands
              Text(
                "RESTAURANTS",
                style: GoogleFonts.tinos(
                  fontSize: baseFontSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(245, 158, 158, 158),
                ),
              ),
              Text(
                "INTERNATIONAL BRANDS",
                style: GoogleFonts.tinos(
                  fontSize: baseFontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
            
              const SizedBox(height: 20), 
              const International_GridView(),
              const SizedBox(height: 20),
    
              // Section: Local Brands
              Text(
                "OUR",
                style: GoogleFonts.tinos(
                  fontSize: baseFontSize * 0.9,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(245, 158, 158, 158),
                ),
              ),
              Text(
                "LOCAL BRANDS",
                style: GoogleFonts.tinos(
                  fontSize: baseFontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
          
    
              const SizedBox(height: 20),
              const Local_Grid_View(),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    ),
  );
}


@override
Widget build(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  final colorScheme = Theme.of(context).colorScheme;
  final userProvider = Provider.of<UserRegistrationProvider>(context, listen: false);

  return StreamBuilder<bool>(
    stream: userProvider.blockedStatusStream(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      bool isBlocked = snapshot.data ?? false;

      if (isBlocked) {
        return  const UserBlockPage();
      }

      // ✅ User NOT blocked → show your actual UI
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
                        builder: (context) => const LoginPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.power_settings_new, size: 20),
                label: Text(
                  "Login",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),

        drawer: const CustomDrawer(),
        body:Stack(
    children: [
      _pages[_currentIndex],
      
      Align(
        alignment: Alignment.bottomCenter,
        child: BottomCartBar(
          onViewCart: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) => FoodCartPage()));
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Careers'),
            BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Media'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: 'Subscription'),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),



        
      );
    },
  );
}
}