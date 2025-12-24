import 'package:agitha/ControllersFolder/RestaurantRatingController.dart';
import 'package:agitha/ModelsFoder/RestaurantReviewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserRestaurantReviewRatingPage extends StatelessWidget {
  final String restaurantname;
  final String rating;
  final String? imageUrl ;
  final String retaurantId;
 
  
  const UserRestaurantReviewRatingPage({
    super.key,
    required this.restaurantname,
    required this.imageUrl,
    required this.rating,
    required this.retaurantId,
  
  
  });
  
// void showResturantRatingAlert(BuildContext context, RestaurantRatingProvider controller) async {

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

//                             RestaurantReviewModel model = RestaurantReviewModel(
//                               docId: "",
//                               restaurantId: retaurantId,
                           
//                               profileImageUrl: "",
//                               username: "",
//                               rating: rating,
//                               review: reviewController.text.trim(),
//                             );

//                             await controller.AddRestaurantRating(model);
//                           await controller.updateAverageRatingRestaurant(retaurantId); 
                            
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
    final colorScheme = Theme.of(context).colorScheme;
    final restaurantRatingController = Provider.of<RestaurantRatingProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
 Row(
            children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
           child: CircleAvatar(
           radius: 60,
           backgroundColor: Colors.grey.shade300,
          foregroundImage: NetworkImage(imageUrl.toString()),
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
               restaurantname,
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
                                    itemSize: 20.0,
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
  stream: restaurantRatingController.getRestauarantReviewsStream(retaurantId),
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