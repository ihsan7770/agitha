import 'package:agitha/ModelsFoder/RestaurantReviewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestaurantRatingProvider extends ChangeNotifier{
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // -------------------------------------------------------------------------
  // ⭐ ADD FOOD RATING
  // -------------------------------------------------------------------------
  Future<void> AddRestaurantRating(RestaurantReviewModel model) async {
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
      final docRef = _firestore.collection("RestaurantRating").doc();

      final updatedModel = RestaurantReviewModel(
        docId: docRef.id,
        restaurantId: model.restaurantId,
      
        profileImageUrl: imageUrl,
    
        username: username,
        rating: model.rating,
        review: model.review,
      );

      // Save data
      await docRef.set(updatedModel.toMap());

      debugPrint("⭐ Restaurant Rating added successfully");

    } catch (e) {
      debugPrint("❌ Rating error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// to get restaurant reviews
Stream<List<Map<String, dynamic>>> getRestauarantReviewsStream(
    
    String restaurantId,
  ) {
  return FirebaseFirestore.instance
      .collection('RestaurantRating')
      
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

// avarage rating calculation

// update rating calculate average
Future<void> updateAverageRatingRestaurant(String restaurantId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 1. Fetch all ratings for this restaurant
  QuerySnapshot ratingSnapshot = await firestore
      .collection('RestaurantRating')
      .where('restaurantId', isEqualTo: restaurantId)
      .get();

  double avgRating = 0;

  // 2. Calculate average rating
  if (ratingSnapshot.docs.isNotEmpty) {
    double total = 0;
    int count = ratingSnapshot.docs.length;

    for (var doc in ratingSnapshot.docs) {
      if (doc.data().toString().contains('rating')) {
        total += (doc['rating'] as num).toDouble();
      }
    }

    avgRating = double.parse((total / count).toStringAsFixed(2));
  }

  // 3. Find company document where restaurantId == given restaurantId
  QuerySnapshot companySnapshot = await firestore
      .collection('companies')
      .where('userId', isEqualTo: restaurantId)
      .get();

  if (companySnapshot.docs.isEmpty) {
    print("No company found for restaurantId = $restaurantId");
    return;
  }

  // 4. Update rating in the matched company document
  String companyDocId = companySnapshot.docs.first.id;

  await firestore.collection('companies').doc(companyDocId).update({
    'rating': avgRating,
  });

  print("Updated company rating: $avgRating for company doc: $companyDocId");
}



// veiw review inrestourent side
Stream<List<Map<String, dynamic>>> getRestaurantSideReviewsStream() {
  final String restaurantId = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('RestaurantRating')
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








}