import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItemModel {
  final String id;
  final String dishName;
  final String price;
  final String category;
  final  double rating;
  final String imageUrl;
  final String restaurantId;     
  final String restaurantName; 
  final String describtion;  
  final DateTime createdAt;

  FoodItemModel({
    required this.id,
    required this.dishName,
    required this.price,
    required this.category,
    required this.describtion,
    this. rating = 0,
    required this.imageUrl,
    required this.restaurantId,
    required this.restaurantName,
    required this.createdAt,
  });

  
  factory FoodItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodItemModel(
      id: doc.id,
      dishName: data['dishName'] ?? '',
      price: data['price'] ?? '',
      category: data['category'],
      describtion:data['describtion'] ?? '',
       rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      restaurantName: data['restaurantName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      "id":id,
      'dishName': dishName,
      'price': price,
      'category':category,
      'describtion':describtion,
      'rating':rating,
      'imageUrl': imageUrl,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
