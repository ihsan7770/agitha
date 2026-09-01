import 'package:agitha/ControllersFolder/DeliveryBoyRatingController.dart';
import 'package:agitha/ControllersFolder/RestaurantRatingController.dart';
import 'package:agitha/ModelsFoder/RestaurantReviewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewDeliveryBoysRatings extends StatelessWidget {
  final String dbname;
  final String rating;
  
  final String deliveryBoyId;
 
  
  const ViewDeliveryBoysRatings({
    super.key,
    required this.dbname,
    
    required this.rating,
    required this.deliveryBoyId,
  
  
  });
  



  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // final restaurantRatingController = Provider.of<RestaurantRatingProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
 Row(
            children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
           child:CircleAvatar(
          radius: 60, // size of the circle
        backgroundColor: Colors.grey.shade300, // background color
          child: const Icon(
    Icons.moped, // scooter icon
    size: 50, // icon size
    color: Colors.black87, // icon color
  ),
),

),

              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                       LayoutBuilder(
          builder: (context, constraints) {
            double nameFontSize =
                MediaQuery.of(context).size.width * 0.07; // base scaling
            nameFontSize = nameFontSize.clamp(16.0, 24.0);
            return Padding(
              padding: const EdgeInsets.only(left: 3.0),
              child: Text(
               dbname,
                style: GoogleFonts.tinos(
                  fontSize: nameFontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
            );
          },
        ),

                              RatingBarIndicator(
                                    rating: double.parse(rating),

                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 16.0,
                                    direction: Axis.horizontal,
                                  ),

                 LayoutBuilder(
                   builder: (context, constraints) {
                     double responsiveFontSize = MediaQuery.of(context).size.width * 0.045;
                     
                     responsiveFontSize = responsiveFontSize.clamp(12.0, 18.0);
                 
                     return Padding(
                       padding: const EdgeInsets.only(left: 3.0),
                       child: Text(
                          rating,
                         style: GoogleFonts.tinos(
                           fontSize: responsiveFontSize,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                         ),
                         softWrap: true,
                         overflow: TextOverflow.visible,
                       ),
                     );
                   },
                 ),

             
                ],
              )
            ],
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0,top:12),
              child: Text("Reviews & Ratings", style: GoogleFonts.tinos(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                             color: Colors.black,
                           ),),
            ),
          ),

         const SizedBox(height: 10,),

          StreamBuilder<List<Map<String, dynamic>>>(
  stream: DeliveryBoyRatingProvider().getDeliveryBoyReviewsStream(deliveryBoyId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("No reviews yet"));
    }

    final reviews = snapshot.data!;

    return ListView.builder(
       shrinkWrap: true,
      // controller:  scrollController,
      physics:const NeverScrollableScrollPhysics(), 
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final item = reviews[index];

        return // // ⭐ SINGLE REVIEW BOX
Padding(
  padding: EdgeInsets.symmetric(horizontal: 12),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // PROFILE IMAGE
    CircleAvatar(
  radius: 22,
  backgroundImage: (item['profileImageUrl'] != null &&
                    item['profileImageUrl'].toString().isNotEmpty)
      ? NetworkImage(item['profileImageUrl'])
      : null,
  child: (item['profileImageUrl'] == null ||
          item['profileImageUrl'].toString().isEmpty)
      ? Icon(Icons.person, size: 26, color: Colors.white)
      : null,
  backgroundColor: Colors.grey.shade400,
),

      const SizedBox(width: 12),

      // NAME + RATING + REVIEW TEXT
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NAME + RATING
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['username'],
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children:  [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    SizedBox(width: 2),
                    Text(
                      item['rating'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )
              ],
            ),

            const SizedBox(height: 4),

            // REVIEW TEXT
            Text(
              item['review'],
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      
    ],
  ),
);
        
        
        
    

      },
    );
  },
),

        ],
      ),
 

    );
  
   


    
  }
}