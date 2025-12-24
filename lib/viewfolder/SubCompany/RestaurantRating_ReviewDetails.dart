import 'package:agitha/ControllersFolder/RestaurantRatingController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantRating_ReviewPage extends StatelessWidget {
  const RestaurantRating_ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
      final restaurantRatingController = Provider.of<RestaurantRatingProvider>(context, listen: false);
    return Scaffold(appBar: AppBar(),
    body: SingleChildScrollView(
      child: Column(
        
        children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text("Ratings & Reviews",
                  style: GoogleFonts.tinos(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color:Colors.black
                      ),
                
                
                )),
            ),
      
            const SizedBox(height: 10,),
      
             StreamBuilder<List<Map<String, dynamic>>>(
        stream: restaurantRatingController.getRestaurantSideReviewsStream(),
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No reviews yet"));
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
      
      
      ],),
    ),
    
    
    );
  }
}