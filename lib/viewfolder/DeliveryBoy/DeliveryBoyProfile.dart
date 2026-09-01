import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyRegistration.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryBoyProfile extends StatefulWidget {
  const DeliveryBoyProfile({super.key});

  @override
  State<DeliveryBoyProfile> createState() => _DeliveryBoyProfileState();
}

class _DeliveryBoyProfileState extends State<DeliveryBoyProfile> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    /// ✅ MediaQuery
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

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
            padding: EdgeInsets.symmetric(
              vertical: h * 0.025,
              horizontal: w * 0.04,
            ),
            child: Column(
              children: [
                SizedBox(height: h * 0.02),

                /// 🔹 IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(w * 0.04),
                  child: Image.network(
                    data['db_licenceUrl'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: h * 0.28,
                    errorBuilder: (context, error, stackTrace) =>
                        const NoInternetWidget(
                      width: double.infinity,
                      height: double.infinity,
                      iconSize: 30,
                      textSize: 8,
                    ),
                  ),
                ),

                SizedBox(height: h * 0.03),

                /// 🔹 CARD
                Card(
                  surfaceTintColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.05),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(w * 0.05),
                    child: Column(
                      children: [
                        /// NAME + EDIT
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['db_name'],
                                style: GoogleFonts.tinos(
                                  fontSize: w * 0.065,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(255, 75, 2, 2),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit, size: w * 0.07),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryBoyRegistration(
                                      db_id: doc.id,
                                      db_name: data['db_name'],
                                      db_phone: data['db_phone'],
                                      db_age: data['db_age'].toString(),
                                      db_gender: data['db_gender'],
                                      db_vehicle: data['db_vehicle'],
                                      db_location: data['db_location'],
                                      db_restaurantname:
                                          data['db_restaurantname'],
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

                        SizedBox(height: h * 0.02),

                        /// INFO ROWS
                        _infoRow(
                          icon: Icons.cake,
                          label: "Age",
                          value: data['db_age'].toString(),
                          w: w,
                        ),
                        _infoRow(
                          icon: Icons.phone,
                          label: "Phone",
                          value: data['db_phone'],
                          w: w,
                        ),
                        _infoRow(
                          icon: Icons.location_on,
                          label: "Location",
                          value: data['db_location'],
                          w: w,
                        ),
                        _infoRow(
                          icon: Icons.person_outline,
                          label: "Gender",
                          value: data['db_gender'],
                          w: w,
                        ),
                        _infoRow(
                          icon: Icons.restaurant,
                          label: "Working Restaurant",
                          value: data['db_restaurantname'],
                          w: w,
                        ),
                        _infoRow(
                          icon: Icons.directions_bike,
                          label: "Vehicle Type",
                          value: data['db_vehicle'],
                          w: w,
                        ),

                        /// AVAILABILITY
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: h * 0.015),
                          child: Row(
                            children: [
                              Text(
                                "Available for Delivery:",
                                style: GoogleFonts.tinos(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const Spacer(),
                              StreamBuilder<bool>(
                                stream: DeliveryBoyHomeController()
                                    .availabilityStream(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  return Transform.scale(
                                    scale: w * 0.0022,
                                    child: Switch(
                                      value: snapshot.data!,
                                      onChanged: (value) {
                                        DeliveryBoyHomeController()
                                            .trueandfalseupdateAvailability(
                                                value);
                                      },
                                      activeColor:
                                          colorScheme.primary,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: h * 0.02),

                        /// LOGOUT
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.08,
                                vertical: h * 0.015,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(w * 0.05),
                              ),
                            ),
                            onPressed: () {
                              AuthenticationController()
                                  .logout(context);
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(fontSize: w * 0.045),
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

  /// 🔹 Reusable Info Row
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required double w,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.025),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: w * 0.05),
          SizedBox(width: w * 0.03),
          Text(
            "$label: ",
            style: GoogleFonts.tinos(
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.tinos(
                fontSize: w * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
