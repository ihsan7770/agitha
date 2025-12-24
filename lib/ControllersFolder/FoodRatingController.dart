import 'package:agitha/ModelsFoder/FoodRating.dart';
import 'package:agitha/ModelsFoder/RatingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FoodRatingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // -------------------------------------------------------------------------
  // ⭐ ADD FOOD RATING
  // -------------------------------------------------------------------------
  Future<void> AddFoodRating(FoodRatingModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw "User not logged in";

      // Fetch user profile
      final snap = await _firestore
          .collection("userprofile")
          .where("loggeduserId", isEqualTo: user.uid)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) throw "User profile not found";

      final data = snap.docs.first.data();
      final username = data["username"] ?? "";
      final imageUrl = data["profileImageUrl"] ?? "";

      // Create document ref
      final docRef = _firestore.collection("foodrating").doc();

      final updatedModel = FoodRatingModel(
        docId: docRef.id,
        restaurantId: model.restaurantId,
        foodname: model.foodname,
        profileImageUrl: imageUrl,
        dishid: model.dishid,
        username: username,
        rating: model.rating,
        review: model.review,
      );

      // Save data
      await docRef.set(updatedModel.toMap());
      _isLoading = false;
      debugPrint("⭐ Rating added successfully");

    } catch (e) {
      debugPrint("❌ Rating error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------------------------------------------------------------------------
  // ⭐ FILTERED STREAM BY RESTAURANT
  // -------------------------------------------------------------------------
Stream<List<Map<String, dynamic>>> getFoodReviewsStream(
    String dishId,
    String restaurantId,
  ) {
  return FirebaseFirestore.instance
      .collection('foodrating')
      .where('dishid', isEqualTo: dishId)
      .where('restaurantId', isEqualTo: restaurantId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return {
              'username': doc['username'],
              'review': doc['review'],
              'rating': doc['rating'],
              'profileImageUrl': doc['profileImageUrl'],
            };
          }).toList());
}




Stream<List<Map<String, dynamic>>> getFoodRatingRestaurant(
    String dishId,
    
  ) {
  return FirebaseFirestore.instance
      .collection('foodrating')
      .where('dishid', isEqualTo: dishId)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            return {
              'username': doc['username'],
              'review': doc['review'],
              'rating': doc['rating'],
              'profileImageUrl': doc['profileImageUrl'],
            };
          }).toList());
}




// update rating calculate average
Future<void> updateAverageRating(String dishId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 1. Get all ratings for this dishId
  QuerySnapshot ratingsSnapshot = await firestore
      .collection('foodrating')
      .where('dishid', isEqualTo: dishId)
      .get();

  if (ratingsSnapshot.docs.isEmpty) {
    // If no rating, set rating = 0
    await firestore.collection('foodItems').doc(dishId).update({
      'rating': 0,
    });
    return;
  }

  // 2. Calculate the average rating
  double total = 0;
  int count = ratingsSnapshot.docs.length;

  for (var doc in ratingsSnapshot.docs) {
    total += (doc['rating'] as num).toDouble();
  }

 double avgRating = double.parse((total / count).toStringAsFixed(2));

  // 3. Update in foodItems collection
  await firestore.collection('foodItems').doc(dishId).update({
    'rating': avgRating,
  
  });
}







}

