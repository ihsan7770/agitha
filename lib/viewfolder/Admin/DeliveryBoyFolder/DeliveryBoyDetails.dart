import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/AdminDBViewRatingPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeliveryBoyDetails extends StatefulWidget {
  final String deliveryboyId;
  final String deliverboyemail;

  const DeliveryBoyDetails({
    super.key,
    required this.deliveryboyId,
    required this.deliverboyemail,
  });

  @override
  State<DeliveryBoyDetails> createState() => _DeliveryBoyDetailsState();
}

class _DeliveryBoyDetailsState extends State<DeliveryBoyDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DeliveryBoyViewProvider>(context, listen: false)
          .fetchDeliveryBoyDetails(widget.deliveryboyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DeliveryBoyViewProvider>(context);
    final deliveryboy = provider.deliveryboys;

    if (deliveryboy == null) {
      return const Scaffold(
        body: Center(child: Text("Delivery Boy details not found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        title: const Text("Delivery Boy Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// CLEAR IMAGE (NO CROP)
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 8),
              child: Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    deliveryboy.db_licenceUrl,
                    fit: BoxFit.contain, // ✅ SHOW FULL IMAGE
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),

         

            
            /// DETAILS CARD (INLINED WIDGETS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                surfaceTintColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                        
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                      deliveryboy.db_name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                      Spacer(),

                                               InkWell(
                                                onTap: (){
                                                  
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewDeliveryBoysRatings(dbname:deliveryboy.db_name,deliveryBoyId: deliveryboy.db_userId,rating: deliveryboy.rating.toString(),)),);


                                                },
                                                 child: Container(
                                                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                               decoration: BoxDecoration(
                                                                 color: Colors.black,
                                                                 borderRadius: BorderRadius.circular(30),
                                                                 boxShadow: const [
                                                                   BoxShadow(color: Colors.black12, blurRadius: 6),
                                                                 ],
                                                               ),
                                                               child: Row(
                                                                 mainAxisSize: MainAxisSize.min,
                                                                 children:  [
                                                                   const Icon(Icons.star, color: Colors.amber, size: 14),
                                                                     const SizedBox(width: 4),
                                                                   Text(
                                                                    deliveryboy.rating.toDouble().toStringAsFixed(1),
                                                                     style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                               ),
                                    ],
                                  ),
                               
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Phone
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.phone, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    deliveryboy.db_phone,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.email, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Email",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    widget.deliverboyemail,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Location
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child:
                                  const Icon(Icons.location_on, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    deliveryboy.db_location,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Gender
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person_outline, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Gender",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    deliveryboy.db_gender,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Age
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.cake, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Age",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    deliveryboy.db_age.toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Vehicle
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.delivery_dining, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Vehicle",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    deliveryboy.db_vehicle,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
