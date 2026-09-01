


import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/ControllersFolder/RestourentHomeController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyProfileFolder/CompanyProfileUpdate.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  void initState() {
    super.initState();
   
  }
 
 
 // table widget
  Widget _buildTableWidget(String image, String count, double screenWidth,{double sizeFactor = 0.27}) { 
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          image,
          width: screenWidth * sizeFactor,
          height: screenWidth * sizeFactor,
        ),
        Text(
          count,
          style: GoogleFonts.tinos(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }







  @override
  Widget build(BuildContext context) {
    
    // final provider = Provider.of<RestaurantHomeProvider>(context);
    // final restaurantss = provider.restaurant;

    double screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;


    final colorScheme = Theme.of(context).colorScheme;

  

    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurant Profile"),
        centerTitle: true,
      ),
      body: StreamBuilder<CompanyRegistrationModel?>(
  stream: context.read<RestaurantHomeProvider>().restaurantStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    if (!snapshot.hasData || snapshot.data == null) {
      return const Text("No restaurant data found");
    }

    final restaurant = snapshot.data!;

    int totalSeats = 
  (restaurant.twoSeat) * 2 +
  (restaurant.fourSeat) * 4 +
  (restaurant.sixSeat) * 6 +
  (restaurant.eightSeat) * 8 +
  (restaurant.tenSeat) * 10;

    return   
    SingleChildScrollView(
                  child: Column(
                    children: [
                      // Stack for banner image and logo
                      Stack(
                        children: [
                          Image.network(
                           restaurant.restaurantImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: screenWidth * 0.58 ,


                            errorBuilder: (context, error, stackTrace) =>
                               NoInternetWidget(
                                width: double.infinity,
                                height: screenHeight * 0.28,
                        iconSize: screenWidth * 0.08,
                        textSize: screenWidth * 0.035,
                               )

                          ),
                       
                          // Edit button
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyProfileUpdate(
                                    location: restaurant.location,
                                    phone: restaurant.phone,
                                    docid: restaurant.id,
                                    restorentName:restaurant.restaurantName,
                                    twoseat: restaurant.twoSeat.toString(),
                                    fourseat: restaurant.fourSeat.toString(),
                                    eightseat:restaurant. eightSeat.toString(),
                                    sixseat:restaurant. sixSeat.toString(),
                                    tenseat:restaurant. tenSeat.toString(),
                                    decorationAmount:restaurant. decorationAmount.toString(),
                                    noDecorationAmount:restaurant. noDecorationAmount.toString(),
                                    reservationAmount: restaurant.reservationAmount.toString(),
                                    brandType: restaurant.brandType,
                                    instagramUrl: restaurant.instagramUrl,
                                    facebookUrl: restaurant.facebookUrl,
                                    twitterUrl: restaurant.twitterUrl,
                                    description: restaurant.description,
                                    imagePathlogo: restaurant.logoUrl,
                                    imagePath:restaurant.restaurantImageUrl,
                                  ),
                                ),
                              );
                            },
                            child:  Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: screenWidth * 0.08,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    size: screenWidth * 0.08,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                        const SizedBox(height: 10,),
                        
                      // Restaurant name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                            children: [
                                             Image.network(
                                              
                                              restaurant.logoUrl,height: screenWidth * 0.35,width: screenWidth * 0.35,

                                              errorBuilder: (context, error, stackTrace) =>
                                               NoInternetWidget(
                                              width: screenWidth * 0.35,
                                              height: screenWidth * 0.35,
                                              iconSize: screenWidth * 0.06,
                                               
                                              textSize: screenWidth * 0.035,
                                             )

                                              
                                              
                                              
                                              ),
                                              const SizedBox(width: 20),


                                             Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// Restaurant Name
      Text(
        restaurant.restaurantName,
        style: GoogleFonts.tinos(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 75, 2, 2),
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 4),

      /// Brand Type
      Text(
        restaurant.brandType,
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
        restaurant.phone,
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
        restaurant.location,
        style: GoogleFonts.tinos(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 6),

      /// Rating Row
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: colorScheme.primary,
            size: screenWidth * 0.05,
          ),
          const SizedBox(width: 5),
          Text(
            restaurant.rating.toStringAsFixed(1),
            style: GoogleFonts.tinos(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),

      const SizedBox(height: 10),
    ],
  ),
)
                                            ],
                                          ),
                              ],
                            ),
                          ),

                      const SizedBox(height: 10),

                      // Description section
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 8.0),
                          child: Text(
                            "Description",
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            restaurant.description,
                            style:  TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Available Tables
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Available Tables",
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Tables row 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTableWidget(
                              "assets/tables/t2r.png", restaurant.twoSeat.toString(), screenWidth),
                          const SizedBox(width: 10),
                          _buildTableWidget(
                              "assets/tables/t4r.png",  restaurant.fourSeat.toString(), screenWidth),
                          const SizedBox(width: 10),
                          _buildTableWidget(
                              "assets/tables/t6r.png", restaurant.sixSeat.toString(), screenWidth),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Tables row 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTableWidget(
                              "assets/tables/t8r.png", restaurant.eightSeat.toString(), screenWidth,sizeFactor: 0.39),
                          const SizedBox(width: 10),
                          _buildTableWidget(
                              "assets/tables/t10r.png",  restaurant.tenSeat.toString(), screenWidth,sizeFactor: 0.43),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Total seats
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, bottom: 8.0),
                          child: Text(
                            "Total Seats",
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ), 
                      

                      

                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, bottom: 8.0),
                          child: Text(
                           totalSeats.toString(),
                            style: GoogleFonts.tinos(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      // Price Details
                      _buildPriceDetailsSection(
                        context,
                         restaurant.reservationAmount.toString(),
                        restaurant. noDecorationAmount.toString(),
                        restaurant. decorationAmount.toString(),
                        screenWidth
                      ),

                      // Social Media Section
                      _buildSocialMediaSection(
                          context,  restaurant.instagramUrl, restaurant. facebookUrl,  restaurant.twitterUrl,screenWidth),
                    ],
                  ),
                );

  },
)

      
      
      
      
      
    
    );
  }

  Widget _buildPriceDetailsSection(
      BuildContext context, String reservationAmount, String noDecorationAmount, String decorationAmount, double screenWidth) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 16.0, bottom: 15.0),
            child: Text(
              "Price Details",
              style: GoogleFonts.tinos(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
       
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text("Reservation Price: ${reservationAmount}",style: TextStyle(fontSize: screenWidth * 0.05),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text("Event Booking Price: $noDecorationAmount",style: TextStyle(fontSize: screenWidth * 0.05)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text("Event Decorating Price: $decorationAmount",style: TextStyle(fontSize: screenWidth * 0.05)),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection(
      BuildContext context, String instagramUrl, String facebookUrl, String twitterUrl ,double screenWidth) {
    final colorScheme = Theme.of(context).colorScheme;

Future<void> openWebsite(String url) async {
  final colorScheme = Theme.of(context).colorScheme;

  if (!url.startsWith('http')) {
    url = 'https://$url'; // Ensure valid format
  }

  final uri = Uri.parse(url);

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Cannot open this link"),
          backgroundColor: colorScheme.primary,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Invalid link"),
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}

    Widget socialRow(String url, IconData icon) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 10),
        child: Row(
          children: [
            InkWell(
              onTap: () => openWebsite(url),
              child: CircleAvatar(
                backgroundColor: Colors.red[100],
                radius:  screenWidth *0.07,
                child: FaIcon(
                  icon,
                  color: colorScheme.primary,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(url, style:  TextStyle(fontSize: screenWidth * 0.04)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 15.0, top: 15.0),
          child: Text(
            "Social Media",
            style: GoogleFonts.tinos(
              fontSize: screenWidth *0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        socialRow(instagramUrl, FontAwesomeIcons.instagram),
        socialRow(facebookUrl, FontAwesomeIcons.facebook),
        socialRow(twitterUrl, FontAwesomeIcons.twitter),

        SizedBox(height: 20,)
      ],
    );
  }
}
