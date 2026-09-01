import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/FoodRatingController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:agitha/ModelsFoder/FoodRating.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:agitha/viewfolder/Widgets/ProfileAlert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomSheetFood extends StatefulWidget {
  final String foodname;
  final String dishid;
  final String price;
  final String foodid;
  final double rating;
  final String foodimg;
  final String describtion;

  const BottomSheetFood({
    super.key,
    required this.foodname,
    required this.dishid,
    required this.price,
    required this.foodid,
    required this.rating,
    required this.foodimg,
    required this.describtion,
  });

  @override
  State<BottomSheetFood> createState() => _BottomSheetFoodState();
}

class _BottomSheetFoodState extends State<BottomSheetFood> {
  






  @override
  Widget build(BuildContext context) {
   final ratingController = Provider.of<FoodRatingProvider>(context, listen: false);

   final String dishId = widget.dishid;
   final String restaurantId = widget.foodid;

    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
     initialChildSize: 1.0,
     maxChildSize: 1.0,
     minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: Image.network(
                    widget.foodimg,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,

                     errorBuilder: (context, error, stackTrace) =>
                      const NoInternetWidget(
                                width: double.infinity,
                                height: 300,
                                iconSize: 50,
                                textSize: 14,
                               )

                               
                  ),
                  
                ),

                const SizedBox(height: 14),

                // TITLE + PRICE ROW
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.foodname,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "₹${widget.price}",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // RATING
                Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,  // 🔥 important → wrap content
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                              ),


                const SizedBox(height: 12),

                // DESCRIPTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.describtion,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

  



// ⭐ RATINGS & REVIEWS TITLE
Padding(
  padding: EdgeInsets.symmetric(horizontal: 12),
  child: Text(
    "Ratings & Reviews",
    style: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
),

const SizedBox(height: 12),


StreamBuilder<List<Map<String, dynamic>>>(
  stream: ratingController.getFoodReviewsStream(dishId,restaurantId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.6,
    child: const Center(
      child: Text(
        "No reviews yet",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
  );
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



const SizedBox(height: 20),





                
              ],
            ),
          ),
        );
      },
    );
  }
}
