import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/viewfolder/Admin/RestorentFolder/ViewRatingsRestaurant.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/User_RestaurantRating_ReviewPage.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewExtraRestourentDetails extends StatefulWidget {
  final String companyId;
  const ViewExtraRestourentDetails({super.key, required this.companyId});

  @override
  State<ViewExtraRestourentDetails> createState() =>
      _ViewExtraRestourentDetailsState();
}

class _ViewExtraRestourentDetailsState
    extends State<ViewExtraRestourentDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantViewProvider>(context, listen: false)
          .fetchCompanyDetails(widget.companyId);
    });
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        print('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

Widget buildTable(int count, double screenWidth, String imageAsset, {double sizeFactor = 0.27}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Image.asset(
        imageAsset,
        width: screenWidth * sizeFactor,
        height: screenWidth * sizeFactor,
      ),
      Text(
        count.toString(),
        style: GoogleFonts.tinos(
          fontSize:screenWidth * 0.05 ,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}


  Widget socialRow(String url, IconData icon, Color bgColor) {
      final Size size = MediaQuery.of(context).size;
      final double width = size.width;
    
     final colorScheme = Theme.of(context).colorScheme;
    bool hasUrl = url.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: hasUrl ? () => _launchUrl(url) : null,
            child: CircleAvatar(
              radius: width * 0.07,
              backgroundColor: hasUrl ? bgColor : Colors.grey[300],
              child: FaIcon(
                icon,
                color: hasUrl ?  colorScheme.primary : Colors.grey,
                size: width * 0.06,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasUrl ? url : 'Not provided',
              style: TextStyle(
                color: hasUrl ? Colors.black : Colors.grey,
                fontSize: width * 0.05
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    
    final provider = Provider.of<RestaurantViewProvider>(context);
    final company = provider.company;
    double screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    if (provider.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (company == null) {
      return Scaffold(
         appBar: AppBar(
        title: const Text("Restaurant Details"),
        centerTitle: true,
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text("Company details not found", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("ID: ${widget.companyId}"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  provider.fetchCompanyDetails(widget.companyId);
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    int totalSeats = 2 * company.twoSeat +
       4 * company.fourSeat +
       6 * company.sixSeat +
       8 *  company.eightSeat +
      10 * company.tenSeat;

    return Scaffold(
      appBar:  AppBar(
        title: const Text("Restaurant Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
                
                    Image.network(
                        company.restaurantImageUrl,
                        width: double.infinity,
                        height:   screenWidth * 0.50,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) =>
                                 NoInternetWidget(
                                width:double.infinity,
                                height:  screenWidth * 0.50,
                                iconSize: screenWidth * 0.9,
                                textSize: screenWidth * 0.35,
                               )
                      ),
                  
          
            const SizedBox(height: 16),

            // Restaurant Name & Brand Type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Row(
            children: [
             Image.network(
             company.logoUrl,
             height: screenWidth * 0.28, // responsive height
             
             width: screenWidth * 0.28,  // responsive width
             fit: BoxFit.cover,
             errorBuilder: (context, error, stackTrace) => NoInternetWidget(
               width: screenWidth * 0.28,
               height: screenWidth * 0.28,
               iconSize: screenWidth * 0.06,
               textSize: screenWidth * 0.022,
             ),
           ),

              const SizedBox(width: 20),

Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// Restaurant Name
      Text(
        company.restaurantName,
        style: GoogleFonts.tinos(
          fontSize: screenWidth * 0.07,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 75, 2, 2),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 4),

      /// Brand Type
      Text(
        company.brandType,
        style: GoogleFonts.tinos(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 4),

      /// Phone
      Text(
        company.phone,
        style: GoogleFonts.tinos(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 4),

      /// Location
      Text(
        company.location,
        style: GoogleFonts.tinos(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 8),

      /// Rating Button
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewRatingRestaurant(
                imageUrl: company.logoUrl,
                rating: company.rating.toString(),
                restaurantname: company.restaurantName,
                retaurantId: company.userId,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star,
                  color: Colors.orange,
                  size: screenWidth * 0.04),
              SizedBox(width: screenWidth * 0.02),
              Text(
                company.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(height: 10),
    ],
  ),
)




            ],
          ),

                  const SizedBox(height: 10),
                  Text("Description",
                      style: GoogleFonts.tinos(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                  Text(company.description,
                      style: TextStyle(fontSize:  screenWidth * 0.04),
                      textAlign: TextAlign.justify),
                ],
              ),
            ),

            

            // Tables
            Padding(
              padding: const EdgeInsets.only(left: 16.0,top: 8.0,bottom: 8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Available Tables",
                      style: GoogleFonts.tinos(fontSize:  screenWidth * 0.06, fontWeight: FontWeight.bold))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTable(company.twoSeat, screenWidth, "assets/tables/t2r.png"),
                const SizedBox(width: 10),
                buildTable(company.fourSeat, screenWidth, "assets/tables/t4r.png"),
                const SizedBox(width: 10),
                buildTable(company.sixSeat, screenWidth, "assets/tables/t6r.png"),
              ],
            ),
            const SizedBox(height: 10),
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTable(company.eightSeat, screenWidth, "assets/tables/t8r.png", sizeFactor: 0.39),
            const SizedBox(width: 10),
            buildTable(company.tenSeat, screenWidth, "assets/tables/t10r.png", sizeFactor: 0.46),
          ],
        ),


            

            Center(
              child: Text("Total Seats: $totalSeats",
                  style: GoogleFonts.tinos(fontSize:  screenWidth * 0.06, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 30),

            // Price Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price Details",
                      style: GoogleFonts.tinos(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Reservation Price: ${company.reservationAmount}",
                      style: GoogleFonts.tinos(fontSize: screenWidth * 0.06)),
                  Text("Event Booking Price: ${company.noDecorationAmount}",
                      style: GoogleFonts.tinos(fontSize: screenWidth * 0.06)),
                  Text("Event Decorating Price: ${company.decorationAmount}",
                      style: GoogleFonts.tinos(fontSize: screenWidth * 0.06)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Social Media
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Social Media",
                      style: GoogleFonts.tinos(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  socialRow(company.instagramUrl, FontAwesomeIcons.instagram, Colors.red[100]!),
                  socialRow(company.facebookUrl, FontAwesomeIcons.facebook, Colors.red[100]!),
                  socialRow(company.twitterUrl, FontAwesomeIcons.twitter, Colors.red[100]!),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
