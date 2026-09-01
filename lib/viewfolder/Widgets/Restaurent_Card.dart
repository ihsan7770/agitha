import 'package:agitha/viewfolder/User/FoodOrderingFolder/Company_dish_page.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final double rating;
  final String restaurantid;
  final String location;
  final String describtion;

  const RestaurantCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.restaurantid,
    required this.location,
    required this.describtion,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDishPage(
              title: title,
              imageUrl: imageUrl,
              location: location,
              rating: rating.toString(),
              restaurantid: restaurantid,
              describtion: describtion,
            ),
          ),
        );
      },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              spreadRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final containerWidth = constraints.maxWidth;
            final containerHeight = constraints.maxHeight;

            final textSize = containerWidth * 0.09;
            final imageWidth = containerWidth;
            final imageHeight = containerHeight * 0.8;

            return Stack(
              children: [
                // 🏷 Title
               Padding(
               padding: const EdgeInsets.all(12.0),
               child: Text(
                 title,
                 maxLines: 1,
                 overflow: TextOverflow.ellipsis,
                 style: GoogleFonts.tinos(
                   fontSize: textSize,
                   fontWeight: FontWeight.bold,
                   color: Colors.black,
                 ),
               ),
             ),

                // 🖼 SAFE IMAGE
                Positioned(
                  top: containerHeight * 0.2,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                      ),
                      child: 
                      
                      Image.network(
                        imageUrl,
                        width: imageWidth,
                        height: imageHeight,
                        fit: BoxFit.cover,

                        // ✅ LOADING STATE
                        loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: imageWidth,
                            height: imageHeight,
                            color: Colors.grey[200],
                            child: const Center(
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                                    );
                                  },
          
                                  // ✅ ERROR STATE (NO INTERNET / FIREBASE DOWN)
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                     return  NoInternetWidget(
                                     width: imageWidth,
                                     height: imageHeight,
                                     iconSize: 40,
                                     textSize: 14,
                                    );
                                         
                                    
                                    
                             
         
                        },
                      ),
                    ),
                  ),
                ),

                // ⭐ Rating
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
