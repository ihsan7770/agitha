import 'package:agitha/ModelsFoder/RatingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RatingProvider extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> AddRating(RatingModel ratingmodel) async {
  _isLoading = true;
  notifyListeners();

  try {
   // ✅ Fetch current user
final user = _auth.currentUser;
if (user == null) {
  debugPrint("User not logged in");
  return;
}

// ✅ Query userprofile where loggeduserId == current UID
final querySnapshot = await _firestore
    .collection("userprofile")
    .where("loggeduserId", isEqualTo: user.uid)
    .limit(1)
    .get();

if (querySnapshot.docs.isEmpty) {
  debugPrint("User profile not found!");
  return;
}

final userProfile = querySnapshot.docs.first.data();
final username = userProfile["username"] ?? "";
final imageurl = userProfile["profileImageUrl"] ?? "";

    // ✅ Create new document
    final docRef = _firestore.collection('rating').doc();

    // ✅ Insert username + userId + generated docId
    ratingmodel =RatingModel(
      docId: docRef.id,
      userId: user.uid,
      profileImageUrl:imageurl ,
      username: username, 
      rating: ratingmodel.rating,
      review: ratingmodel.review,
    );



    await docRef.set( ratingmodel .toMap());
    debugPrint("Rating and Review added successfully!");

  } catch (e) {
    debugPrint("Error saving rating: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


// strem to show rating
Stream<List<RatingModel>> ratingStream() {
  return _firestore
      .collection('rating')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return RatingModel.fromMap(doc.data(), doc.id);
    }).toList();
  });
}




}












