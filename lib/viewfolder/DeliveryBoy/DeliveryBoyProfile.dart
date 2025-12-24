import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyRegistration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryBoyProfile extends StatefulWidget {
  const DeliveryBoyProfile({super.key});

  @override
  State<DeliveryBoyProfile> createState() => _DeliveryBoyProfileState();
}

class _DeliveryBoyProfileState extends State<DeliveryBoyProfile> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      
      body: StreamBuilder(
        stream: DeliveryBoyHomeController().streamCurrentDeliveryBoy(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final doc = snapshot.data;
          if (doc == null) {
            return const Center(child: Text("No Delivery Boy Found"));
          }

          final data = doc.data()!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                // IMAGE
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    data['db_licenceUrl'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 220,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
                const SizedBox(height: 20),

                // SINGLE CARD FOR ALL DETAILS
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Name + Edit button
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['db_name'],
                                style: GoogleFonts.tinos(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 75, 2, 2),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 28),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeliveryBoyRegistration(
                                      db_id: doc.id,
                                      db_name: data['db_name'],
                                      db_phone: data['db_phone'],
                                      db_age: data['db_age'].toString(),
                                      db_gender: data['db_gender'],
                                      db_vehicle: data['db_vehicle'],
                                      db_location: data['db_location'],
                                      db_restaurantname: data['db_restaurantname'],
                                      working_restaurant_docId:
                                          data['working_restaurant_docId'],
                                      db_licenceUrl: data['db_licenceUrl'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // PERSONAL INFO ROWS (directly in card)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(Icons.cake, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              Text(
                                "Age: ",
                                style: GoogleFonts.tinos(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data['db_age'].toString(),
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              Text(
                                "Phone: ",
                                style: GoogleFonts.tinos(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data['db_phone'],
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              Text(
                                "Location: ",
                                style: GoogleFonts.tinos(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data['db_location'],
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(Icons.person_outline, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              Text(
                                "Gender: ",
                                style: GoogleFonts.tinos(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data['db_gender'],
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(Icons.restaurant, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              Text(
                                "Working Restaurant: ",
                                style: GoogleFonts.tinos(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data['db_restaurantname'],
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Icon(Icons.directions_bike, color: Colors.grey[700]),
                              const SizedBox(width: 12),
                              Text(
                                "Vehicle Type: ",
                                style: GoogleFonts.tinos(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data['db_vehicle'],
                                  style: GoogleFonts.tinos(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        
                        Padding(
  padding: const EdgeInsets.symmetric(vertical: 10.0),
  child: Row(
    children: [
      Text(
        "Available for Delivery: ",
        style: GoogleFonts.tinos(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      Spacer(),
      StreamBuilder<bool>(
        stream: DeliveryBoyHomeController().availabilityStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          bool isAvailable = snapshot.data!;

          return Transform.scale(
            scale: 0.7,
            child: Switch(
              value: isAvailable,
              onChanged: (value) {
               DeliveryBoyHomeController().trueandfalseupdateAvailability(value); // update Firestore
              },
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Colors.grey,
            ),
          );
        },
      ),
    ],
  ),
),

                  

                        const SizedBox(height: 20),

               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Align(
                  alignment: Alignment.bottomRight,
                   child: ElevatedButton(
                         onPressed: () { 
                            AuthenticationController().logout(context);
                         },
                         style: ElevatedButton.styleFrom(
                         backgroundColor:
                         Theme.of(context).colorScheme.primary,
                         foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                         ),
                         ),
                            child: const Text("Logout"),
                          ),
                 ),
               ),


                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
