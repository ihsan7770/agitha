import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/EventForm.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookEventAndReservationPage extends StatelessWidget {
  final String imageUrl;
  final String restaurantid;
  final String restaurantName;
  final String restourentLocation;
  const BookEventAndReservationPage({
    super.key,
     required this.imageUrl,
     required this.restaurantid,
     required this.restaurantName,
     required this.restourentLocation,
  
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallHeight = size.height < 720;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// -------- Reservation --------
            Image.asset(
              "assets/Reserve.png",
              height: isSmallHeight ? 160 : 180,
              width: size.width * 0.75,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              "Make your reservation now, Enjoy great food and warm hospitality",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallHeight ? 14 : 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () async {

    
    bool loggedIn = await Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).checkLogin(context);

    if (loggedIn) {
      final profileService =
          Provider.of<UserRegistrationProvider>(context, listen: false);

      bool exists = await profileService.checkUserProfileExists();

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete profile for reservation')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileFormPage()),
        );
      } else {
        
           Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  Reservation(
                        imageUrl: imageUrl,
                         restaurantid: restaurantid
                          , restaurantName: restaurantName,
                          restourentLocation: restourentLocation,
                                                  ),
                    ),
                  );


      }
    
  }
},




                
            
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Reservation",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// -------- Event Booking --------
            Image.asset(
              "assets/event.png",
              height: isSmallHeight ? 170 : 190,
              width: size.width * 0.7,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              "Book your special event with us, Enjoy delicious food and beautiful moments",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallHeight ? 14 : 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                 onPressed: () async {

    
    bool loggedIn = await Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).checkLogin(context);

    if (loggedIn) {
      final profileService =
          Provider.of<UserRegistrationProvider>(context, listen: false);

      bool exists = await profileService.checkUserProfileExists();

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete profile for Event Booking')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileFormPage()),
        );
      } else {
        
             Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  EventForm(
                          imageUrl: imageUrl,
                         restaurantid: restaurantid
                          , restaurantName: restaurantName,
                          restourentLocation: restourentLocation,




                      )),
                  );


      }
    
  }
},
               
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Event Booking",
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
