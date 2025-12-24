
import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/ControllersFolder/RestourentHomeController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyProfileFolder/CompanyProfileUpdate.dart';


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
    
    final provider = Provider.of<RestaurantHomeProvider>(context);
    final restaurantss = provider.restaurant;

    double screenWidth = MediaQuery.of(context).size.width;

    // // Sample URLs and images
    // String instagramUrl = restaurantss?.instagramUrl?.toString() ?? "https://www.instagram.com/";
    // String facebookUrl =restaurantss?.facebookUrl?.toString() ?? "https://www.facebook.com/";
    // String twitterUrl = restaurantss?.twitterUrl?.toString() ??"https://twitter.com/";
    // String imagePath = restaurantss?.restaurantImageUrl?.toString()??'assets/projectimages/2nd.jpg';
    // String logoPath =restaurantss?.logoUrl?.toString() ?? 'assets/projectimages/beefberbgr.png' ;

//     // Default values if restaurant is null
//     String restaurantName = restaurantss?.restaurantName ?? "Restaurant Name";
//   int twoseats = restaurantss?.twoSeat ?? 0;
// int fourseats = restaurantss?.fourSeat ?? 0;
// int sixseats = restaurantss?.sixSeat ?? 0;
// int eightseats = restaurantss?.eightSeat ?? 0;
// int tenseats = restaurantss?.tenSeat ?? 0;
// // int reservationNumber = restaurant?.reservationNumber?? 0;
// int reservationAmount = restaurantss?.reservationAmount ?? 0;
// int noDecorationAmount = restaurantss?.noDecorationAmount ?? 0;
// int decorationAmount = restaurantss?.decorationAmount ?? 0;

//     String brandType = restaurantss?.brandType ?? "Brand Type";
//     String companyDescribtion = restaurantss?.description ??
//         "Agthia-Food Company focuses on sustainable and high-quality food concepts aiming to enhance human health and the environment for future generations.";

    final colorScheme = Theme.of(context).colorScheme;

    // // URL launcher function
    // Future<void> _launchUrl(String url) async {
    //   final uri = Uri.parse(url);
    //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    //     throw Exception('Could not launch $url');
    //   }
    // }
    
   

  // int totalSeats = 
  //   (restaurant?.twoSeat ?? 0) * 2 +
  //   (restaurant?.fourSeat ?? 0) * 4 +
  //   (restaurant?.sixSeat ?? 0) * 6 +
  //   (restaurant?.eightSeat ?? 0) * 8 +
  //   (restaurant?.tenSeat ?? 0) * 10;


    return Scaffold(
      appBar: AppBar(),
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

    return   SingleChildScrollView(
                  child: Column(
                    children: [
                      // Stack for banner image and logo
                      Stack(
                        children: [
                          Image.network(
                           restaurant.restaurantImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 180,
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
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.edit,
                                    size: 30,
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
                                             Image.network(restaurant.logoUrl,height: 130,width: 130,),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                
                                
                                                       LayoutBuilder(
                                          builder: (context, constraints) {
                                            double nameFontSize =
                                                MediaQuery.of(context).size.width * 0.07; // base scaling
                                            nameFontSize = nameFontSize.clamp(16.0, 24.0);
                                            return Text(
                                             restaurant.restaurantName,
                                              style: GoogleFonts.tinos(
                                                fontSize: nameFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(255, 75, 2, 2),
                                              ),
                                            );
                                          },
                                        ),
                                
                                
                                
                                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            double phoneFontSize =
                                                MediaQuery.of(context).size.width * 0.04; // base scaling
                                            phoneFontSize = phoneFontSize.clamp(14.0, 20.0);
                                            return Text(
                                              restaurant.brandType,
                                              style: GoogleFonts.tinos(
                                                fontSize: phoneFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            );
                                          },
                                        ),

                                                  LayoutBuilder(
                                          builder: (context, constraints) {
                                            double phoneFontSize =
                                                MediaQuery.of(context).size.width * 0.04; // base scaling
                                            phoneFontSize = phoneFontSize.clamp(14.0, 20.0);
                                            return Text(
                                              restaurant.phone,
                                              style: GoogleFonts.tinos(
                                                fontSize: phoneFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                            LayoutBuilder(
                                          builder: (context, constraints) {
                                            double nameFontSize =
                                                MediaQuery.of(context).size.width * 0.0; // base scaling
                                            nameFontSize = nameFontSize.clamp(16.0, 24.0);
                                            return Text(
                                             restaurant.location,
                                              style: GoogleFonts.tinos(
                                                fontSize: nameFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                              ),
                                            );
                                          },
                                        ),
                                
                                                  LayoutBuilder(
                                          builder: (context, constraints) {
                                            double phoneFontSize =
                                                MediaQuery.of(context).size.width * 0.04; // base scaling
                                            phoneFontSize = phoneFontSize.clamp(14.0, 20.0);
                                            return Row(
                                  children:  [
                                     Icon(
                                      Icons.star,
                                      color: colorScheme.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      restaurant.rating.toString(),
                                        style: GoogleFonts.tinos(
                                                fontSize: phoneFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                    ),
                                  ],
                                );
                                
                                          },
                                        ),
                                           
                                
                                                  const SizedBox(height: 10),
                                                 
                                                ],
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
                              fontSize: 20,
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
                            style: const TextStyle(
                              fontSize: 16,
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
                              fontSize: 25,
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
                              fontSize: 20,
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
                              fontSize: 35,
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
                      ),

                      // Social Media Section
                      _buildSocialMediaSection(
                          context,  restaurant.instagramUrl, restaurant. facebookUrl,  restaurant.twitterUrl),
                    ],
                  ),
                );
    
    
    
    
   


  },
)

      
      
      
      
      
    
    );
  }

  Widget _buildPriceDetailsSection(
      BuildContext context, String reservationAmount, String noDecorationAmount, String decorationAmount) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
            child: Text(
              "Price Details",
              style: GoogleFonts.tinos(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
       
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text("Reservation Price: ${reservationAmount}"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text("Event Booking Price: $noDecorationAmount"),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text("Event Decorating Price: $decorationAmount"),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaSection(
      BuildContext context, String instagramUrl, String facebookUrl, String twitterUrl) {
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
                radius: 25,
                child: FaIcon(
                  icon,
                  color: colorScheme.primary,
                  size: 25,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(url, style: const TextStyle(fontSize: 16)),
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
              fontSize: 23,
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
