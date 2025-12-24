
import 'package:flutter/material.dart';

class FoodRatingAlert extends StatelessWidget {
  const FoodRatingAlert({super.key});

@override
Widget build(BuildContext context) {
  return
 AlertDialog(
          title: const Text('Rating & Review'),
          
          actions: [
          
            TextButton(
              onPressed: () {
               
              },
              child: const Text('Send'),
            ),
          ],
        );
  
  
  
  
  
  
}
}