import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/FoodRatingController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:agitha/ModelsFoder/FoodRating.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
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
  
// void showRatingAlert(BuildContext context, FoodRatingProvider controller) async {
//   final String restaurantId = widget.foodid;
//   final String foodName = widget.foodname;
//   final String dishid =widget.dishid;
//   final colorScheme = Theme.of(context).colorScheme;

//   double rating = 0;
//   bool showRatingError = false;
//   bool showReviewError = false;
//   TextEditingController reviewController = TextEditingController();

//   showDialog(
//     context: context,
//     useRootNavigator: true,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             contentPadding: EdgeInsets.zero,
//             content: Container(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Share your delicious experience",
//                     style: GoogleFonts.tinos(
//                       fontSize: 23,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),

//                   const SizedBox(height: 12),

//                   /// ⭐ RATING STARS
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return IconButton(
//                         onPressed: () {
//                           setState(() {
//                             rating = index + 1.0;
//                             showRatingError = false;
//                           });
//                         },
//                         icon: Icon(
//                           index < rating ? Icons.star : Icons.star_border,
//                           color: showRatingError ? Colors.red : Colors.amber,
//                           size: showRatingError ? 38 : 32,
//                         ),
//                       );
//                     }),
//                   ),

//                   const SizedBox(height: 8),

//                   // /// ⭐ RATING ERROR MESSAGE
//                   // if (showRatingError)
//                   //   Text(
//                   //     "Please select a rating",
//                   //     style: TextStyle(color: Colors.red, fontSize: 13),
//                   //   ),

//                   const SizedBox(height: 12),

//                   /// ✍ REVIEW FIELD
//                   TextField(
//                     controller: reviewController,
//                     maxLines: 3,
//                     decoration: InputDecoration(
//                       hintText: "Write your review...",
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       errorText: showReviewError ? "Review cannot be empty" : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: showReviewError ? Colors.red : colorScheme.primary,
//                           width: 2,
//                         ),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           style: OutlinedButton.styleFrom(
//                             side: BorderSide(color: colorScheme.primary, width: 1.5),
//                           ),
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text("Cancel"),
//                         ),
//                       ),

//                       const SizedBox(width: 12),

//                       Expanded(
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: colorScheme.primary,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           onPressed: () async {
//                             setState(() {
//                               showRatingError = rating == 0;
//                               showReviewError = reviewController.text.trim().isEmpty;
//                             });

//                             if (showRatingError || showReviewError) return;

//                             Navigator.pop(context);

//                             FoodRatingModel model = FoodRatingModel(
//                               docId: "",
//                               restaurantId: restaurantId,
//                               dishid: dishid ,
//                               foodname: foodName,
//                               profileImageUrl: "",
//                               username: "",
//                               rating: rating,
//                               review: reviewController.text.trim(),
//                             );

//                             await controller.AddFoodRating(model);
//                             await controller.updateAverageRating(model.dishid); 
                            
//                           },
//                           child: const Text(
//                             "Send",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }







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
                      widget.rating.toString(),
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



const SizedBox(height: 20),





                
              ],
            ),
          ),
        );
      },
    );
  }
}
