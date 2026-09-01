import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/AdminDBViewRatingPage.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
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

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;


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

      /// ================= IMAGE SECTION =================
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.01,
        ),
        child: Container(
          height: height * 0.32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(width * 0.05),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width * 0.05),
            child: Image.network(
              deliveryboy.db_licenceUrl,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) =>
                  NoInternetWidget(
                    width: double.infinity,
                    height: double.infinity,
                    iconSize: width * 0.08,
                    textSize: width * 0.025,
                  ),
            ),
          ),
        ),
      ),

      /// ================= DETAILS CARD =================
      Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.05),
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              children: [

                /// -------- NAME + RATING --------
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          deliveryboy.db_name,
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewDeliveryBoysRatings(
                                dbname: deliveryboy.db_name,
                                deliveryBoyId: deliveryboy.db_userId,
                                rating: deliveryboy.rating.toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.025,
                            vertical: height * 0.005,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber,
                                  size: width * 0.04),
                              SizedBox(width: width * 0.01),
                              Text(
                                deliveryboy.rating
                                    .toDouble()
                                    .toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: width * 0.032,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// -------- INFO ROWS --------
                infoRow(
                  icon: Icons.phone,
                  label: "Phone",
                  value: deliveryboy.db_phone,
                  width: width,
                ),

                infoRow(
                  icon: Icons.email,
                  label: "Email",
                  value: widget.deliverboyemail,
                  width: width,
                ),

                infoRow(
                  icon: Icons.location_on,
                  label: "Location",
                  value: deliveryboy.db_location,
                  width: width,
                ),

                infoRow(
                  icon: Icons.person_outline,
                  label: "Gender",
                  value: deliveryboy.db_gender,
                  width: width,
                ),

                infoRow(
                  icon: Icons.cake,
                  label: "Age",
                  value: deliveryboy.db_age.toString(),
                  width: width,
                ),

                infoRow(
                  icon: Icons.delivery_dining,
                  label: "Vehicle",
                  value: deliveryboy.db_vehicle,
                  width: width,
                ),
              ],
            ),
          ),
        ),
      ),

      SizedBox(height: height * 0.03),
    ],
  )



      ),
    );
  }


  Widget infoRow({
  required IconData icon,
  required String label,
  required String value,
  required double width,
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
