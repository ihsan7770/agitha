import 'package:agitha/ControllersFolder/RestourentDelivaryBoyController.dart';
import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/AdminDBViewRatingPage.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompanyDeliveryBoyDetails extends StatelessWidget {
  final String deliveryboyId;
  final String deliverboyemail;

  const CompanyDeliveryBoyDetails({
    super.key,
    required this.deliveryboyId,
    required this.deliverboyemail,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final restaurantController =
        Provider.of<RestaurentDeliveryBoyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Boy Details"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<DeliveryBoyModel>>(
        stream:
            restaurantController.streamDeliveryBoyDetails(deliveryboyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No delivery boy found"));
          }

          final List<DeliveryBoyModel> deliveryBoys = snapshot.data!;

          return ListView.builder(
            itemCount: deliveryBoys.length,
            itemBuilder: (context, index) {
              final DeliveryBoyModel boy = deliveryBoys[index];

              return Column(
                children: [
                  /// LICENSE IMAGE
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.04,
                      screenWidth * 0.04,
                      screenWidth * 0.04,
                      screenHeight * 0.01,
                    ),
                    child: Container(
                      height: screenHeight * 0.32,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                        child: Image.network(
                          boy.db_licenceUrl,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) =>
                              const NoInternetWidget(
                            width: double.infinity,
                            height: double.infinity,
                            iconSize: 30,
                            textSize: 8,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// DETAILS CARD
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.05),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.all(screenWidth * 0.04),
                        child: Column(
                          children: [
                            /// NAME & RATING
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.015),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      boy.db_name,
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            screenWidth * 0.05,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ViewDeliveryBoysRatings(
                                            dbname: boy.db_name,
                                            deliveryBoyId:
                                                boy.db_userId,
                                            rating: boy.rating
                                                .toDouble()
                                                .toStringAsFixed(1),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(
                                        horizontal:
                                            screenWidth * 0.02,
                                        vertical:
                                            screenHeight * 0.005,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(
                                                screenWidth * 0.08),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size:
                                                screenWidth * 0.04,
                                          ),
                                          SizedBox(
                                              width:
                                                  screenWidth * 0.01),
                                          Text(
                                            boy.rating
                                                .toDouble()
                                                .toStringAsFixed(1),
                                            style: TextStyle(
                                              fontSize:
                                                  screenWidth * 0.035,
                                              color: Colors.white,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _infoRow(
                              icon: Icons.phone,
                              label: "Phone",
                              value: boy.db_phone,
                              width: screenWidth,
                              screenHeight: screenHeight,
                            ),
                            _infoRow(
                              icon: Icons.email,
                              label: "Email",
                              value: deliverboyemail,
                              width: screenWidth,
                              screenHeight: screenHeight,
                            ),
                            _infoRow(
                              icon: Icons.location_on,
                              label: "Location",
                              value: boy.db_location,
                              width: screenWidth,
                              screenHeight: screenHeight,
                            ),
                            _infoRow(
                              icon: Icons.person_outline,
                              label: "Gender",
                              value: boy.db_gender,
                              width: screenWidth,
                              screenHeight: screenHeight,
                            ),
                            _infoRow(
                              icon: Icons.cake,
                              label: "Age",
                              value: boy.db_age.toString(),
                            width: screenWidth,
                              screenHeight: screenHeight,
                            ),
                            _infoRow(
                              icon: Icons.delivery_dining,
                              label: "Vehicle",
                              value: boy.db_vehicle,
                              width: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// REUSABLE INFO ROW
Widget _infoRow({
  required IconData icon,
  required String label,
  required String value,
  required double width,
  required double screenHeight,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: width * 0.03),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(width * 0.025),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: width * 0.05),
        ),
        SizedBox(width: width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: width * 0.03,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
