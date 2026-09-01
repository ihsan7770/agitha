import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agitha/ControllersFolder/InternetClass.dart';
import 'package:agitha/viewfolder/User/NoInternet.dart';
import 'package:agitha/viewfolder/Widgets/Carousel_Slider.dart';
import 'package:agitha/viewfolder/Widgets/International_GridView.dart';
import 'package:agitha/viewfolder/Widgets/Local_GridView.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: StreamBuilder<bool>(
        stream: NetworkService.internetStatusStream,
        builder: (context, snapshot) {
          // 🚫 No Internet
          if (snapshot.hasData && snapshot.data == false) {
            return const NoInternetPage();
          }

          // ✅ Internet Available
          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = MediaQuery.of(context).size.width;
              final baseFontSize = screenWidth * 0.045;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const CarouselImageSlider(),
                    const SizedBox(height: 20),

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
          );
        },
      ),
    );
  }
}
