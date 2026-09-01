import 'package:agitha/ControllersFolder/RatingController.dart';
import 'package:agitha/ControllersFolder/RatingController.dart';
import 'package:agitha/ControllersFolder/RatingController.dart';
import 'package:agitha/ModelsFoder/RatingModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
     final RatingProviders = Provider.of<RatingProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title:const Text("Ratings and Reviews"), 
        centerTitle: true,
        
      ),
      body: 
      
      
      
      
      StreamBuilder<List<RatingModel>>(
        stream:RatingProviders.ratingStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: CircularProgressIndicator(),
                  ));
                }
               

                       if (!snapshot.hasData || snapshot.data!.isEmpty) {
       return const Center(
         child: Text(
           "No ratings and reviews found",
           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
         ),
       );
     }
        

                final ratingdata = snapshot.data!;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ratingdata.length,
                itemBuilder: (context, index) {
                  final rat = ratingdata[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
              
                                                    CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.grey.shade300,
                            
                              // ✅ foregroundImage handles null safely
                              foregroundImage: (rat.profileImageUrl != null &&
                                      rat.profileImageUrl!.isNotEmpty)
                                  ? NetworkImage(rat.profileImageUrl!)
                                  : null,
                            
                              child: (rat.profileImageUrl == null ||
                                      rat.profileImageUrl!.isEmpty)
                                  ? const Icon(
                                      Icons.person,
                                      size: 23,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
              
              
              
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                   rat.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  RatingBarIndicator(
                                    rating: rat.rating,
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            rat.review,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
        
        
        }
      ),
    );
  }
}
