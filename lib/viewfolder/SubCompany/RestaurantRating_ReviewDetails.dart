import 'package:agitha/ControllersFolder/RestaurantRatingController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RestaurantRating_ReviewPage extends StatelessWidget {
  const RestaurantRating_ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<RestaurantRatingProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ratings & Reviews"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: controller.getRestaurantSideReviewsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No reviews yet",
              
              ),
            );
          }

          final reviews = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: reviews.length,
            separatorBuilder: (_, __) =>
                Divider(color: Colors.grey.shade300, height: 28),
            itemBuilder: (context, index) {
              final item = reviews[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        item['profileImageUrl'] != null &&
                                item['profileImageUrl']
                                    .toString()
                                    .isNotEmpty
                            ? NetworkImage(item['profileImageUrl'])
                            : null,
                    child: item['profileImageUrl'] == null ||
                            item['profileImageUrl']
                                .toString()
                                .isEmpty
                        ? const Icon(Icons.person,
                            color: Colors.white, size: 26)
                        : null,
                  ),

                  const SizedBox(width: 14),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        Text(
                          item['username'],
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Star Rating Row
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < item['rating']
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Review Text
                        Text(
                          item['review'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
