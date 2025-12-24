import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventOrdersPage extends StatefulWidget {
  const EventOrdersPage({super.key});

  @override
  State<EventOrdersPage> createState() => _EventOrdersPageState();
}

class _EventOrdersPageState extends State<EventOrdersPage> {
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
    final colorScheme = Theme.of(context).colorScheme;
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
                    OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                    side:BorderSide(color:colorScheme.primary, width: 1.5),
                                         ),
                                    onPressed: () {},
                                                                         
                                    child: const Text("Cancel"),
                                     ),
                                                               
                                              const Spacer(),  
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // _showAlertbox();
                       
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const ReservationPaymentDetails(),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("Confirm"),
                      ),
                    ),
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