import 'package:agitha/viewfolder/User/EventBookingFolder/EventForm.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BookEventAndReservationPage extends StatelessWidget {
  const BookEventAndReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
             Image.asset("assets/Reserve.png",height: 280,width: 400,),
            
               const Padding(
                 padding: EdgeInsets.all(8.0),
                 child: Text(
                  "Make your reservation now, Enjoy great food and warm hospitality",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                               ),
               ),
              const SizedBox(height: 12),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton(
                            onPressed: () {

                                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Reservation()),
              );
                              

                            },
                            style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            ),
                            ),
                               child: const Text("Reservation"),
                             ),
                    ),
                  ),
        
        
                  Image.asset("assets/event.png",height: 300,width: 300,),
           
               const Padding(
                 padding: EdgeInsets.all(8.0),
                 child: Text(
                  "Book your special event with us, Enjoy delicious food and beautiful moments",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                               ),
               ),
 const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton(
                      onPressed: () { 
                           Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const EventForm()),
                           );
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      ),
                      ),
                         child: const Text("Event Booking"),
                       ),
                    ),
                  ),
        
        
        
        
          ],
        ),
      ),



    );
  }
}