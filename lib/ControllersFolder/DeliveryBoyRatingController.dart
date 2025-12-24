import 'package:agitha/ModelsFoder/DeliveryBoyRatingModel.dart';
import 'package:agitha/ModelsFoder/RestaurantReviewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryBoyRatingProvider extends ChangeNotifier{
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // -------------------------------------------------------------------------
  // ⭐ ADD FOOD RATING
  // -------------------------------------------------------------------------
  Future<void> AddDeliverBoyRating(DeliveryBoyRatingModel model) async {
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
      final docRef = _firestore.collection("DeliveryBoyRating").doc();

      final updatedModel = DeliveryBoyRatingModel(
        docId: docRef.id,
        dboyId: model.dboyId,
        userId:user.uid,

      
        profileImageUrl: imageUrl,
    
        username: username,
        rating: model.rating,
        review: model.review,
      );

      // Save data
      await docRef.set(updatedModel.toMap());

      debugPrint("⭐ DeliveryBoy Rating added successfully");

    } catch (e) {
      debugPrint("❌ db Rating error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// to get restaurant reviews
Stream<List<Map<String, dynamic>>> getDeliveryBoyReviewsStream(
    
    String DeliveryBoyId,
  ) {
  return FirebaseFirestore.instance
      .collection('DeliveryBoyRating')
      
      .where('dboyId', isEqualTo: DeliveryBoyId)
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
Future<void> updateAverageRatingDeliveryBoy(String  dboyId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 1. Fetch all ratings for this db
  QuerySnapshot ratingSnapshot = await firestore
      .collection('DeliveryBoyRating')
      .where('dboyId', isEqualTo:  dboyId)
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

  // 3. Find company document where dbId == given dbId
  QuerySnapshot companySnapshot = await firestore
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: dboyId)
      .get();

  if (companySnapshot.docs.isEmpty) {
    print("No deliveryboy found for deliveryboyId = $dboyId");
    return;
  }

  // 4. Update rating in the matched company document
  String companyDocId = companySnapshot.docs.first.id;

  await firestore.collection('deliveryBoys').doc(companyDocId).update({
    'rating': avgRating,
  });

  print("Updated company rating: $avgRating for delivery doc: $companyDocId");
}



// veiw review inDeliveryBoy side
Stream<List<Map<String, dynamic>>> getDeliveryBoySideReviewsStream() {
  final String deliveryboyId = FirebaseAuth.instance.currentUser!.uid;

  return FirebaseFirestore.instance
      .collection('DeliveryBoyRating')
      .where('dboyId', isEqualTo: deliveryboyId)
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

//show delivery boy ratifn inadmin side






}