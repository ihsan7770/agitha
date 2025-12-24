// import 'package:agitha/User/FoodAddingPage.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  // final String foodName;
  // final String foodDetails;
  // final String imageUrl;

  const FoodCard({
    super.key,
    // required this.foodName,
    // required this.foodDetails,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: (){
      //    Navigator.push(
      //    context,MaterialPageRoute(builder: (context) => const FoodAddingPage()),);
      // 
      // 
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
               "assets/projectimages/3rd.jpg",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
      
            // Name, details & like button
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food name & details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hotel Name",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Hotel Details",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
      
                  // Like button
                  // IconButton(
                  //   icon: const Icon(Icons.favorite_border),
                  //   color: Colors.red,
                  //   onPressed: () {
                  //     // TODO: handle like action
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
