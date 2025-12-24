import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookedEventsPage extends StatefulWidget {
  const BookedEventsPage({super.key});

  @override
  State<BookedEventsPage> createState() => _BookedEventsPageState();
}

class _BookedEventsPageState extends State<BookedEventsPage> {

  final List<Map<String, dynamic>> reservations = [
    {
      'name': 'Mohammed Ihsan',
      'phone': '9865787443',
      'email': 'Mohammwedihsan12@gmail.com',
      'type': 'FareWell',
      'date': 'Friday, September 19, 2025',
      'party': '2',
      'decoration':'No decoration',
      'time': '2:00 PM',
      'duration': '1 hour',
    },
    {
      'name': 'Aisha Rahman',
      'phone': '9876543210',
      'email': 'aisha.rahman@gmail.com',
      'type': 'Birthday Party',
      'date': 'Saturday, October 12, 2025',
      'party': '4',
      'decoration':'Handled by event team',
      'time': '6:30 PM',
      'duration': '2 hours',
    },
  ];
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];

        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation['name'],
                  style: GoogleFonts.tinos(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
                Text(
                  reservation['phone'],
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reservation['email'],
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Divider(color: Color.fromARGB(255, 75, 2, 2)),
                
                Text(
                  reservation['type'],
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),

                   Text(
                  reservation['decoration'],
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),




                Text(
                  "● ${reservation['date']}",
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "● Party of ${reservation['party']}",
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "● ${reservation['time']}",
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "● ${reservation['duration']}",
                  style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),




                Row(
                  children: [

                    Text("Event Booked", style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),),

                       const Spacer(),

                     Text("Paid : 1000", style: GoogleFonts.tinos(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),),






                   
                                                               
                   
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}