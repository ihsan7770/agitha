import 'package:agitha/ModelsFoder/SubscribtionModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:uuid/uuid.dart';


class SubscriptionController  extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

    bool _isLoading = false;
  bool get isLoading => _isLoading;


Future<void> addSubscription(Subscription subscription) async {
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

    // ✅ Create new document
    final docRef = _firestore.collection('subscriptions').doc();

    // ✅ Insert username + userId + generated docId
    subscription = Subscription(
      documentId: docRef.id,
      userId: user.uid,
      email: subscription.email,
      username: username, // 👈 added from userprofile
      
    );

    await docRef.set(subscription.toMap());
    debugPrint("✅ Subscription added successfully!");

  } catch (e) {
    debugPrint("Error saving subscription: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}



// Future<String?> addSubscription(String email) async {
//   final user = _auth.currentUser;
//   if (user == null) return "User not logged in";
//   if (email.isEmpty) return "Email cannot be empty";

//   final docRef = _firestore.collection('subscriptions').doc(user.uid);

//   final docSnapshot = await docRef.get();

//   if (docSnapshot.exists) {
//     return "You are already subscribed!";
//   }

//   Subscription subscription = Subscription(
//     documentId: user.uid,
//     userId: user.uid,
//     email: email,
//   );

//   await docRef.set(subscription.toMap());

//   return "Subscription successful!";
// }



  /// Stream to listen user subscription data
Stream<List<Subscription>> subscriptionStream() {
  return _firestore
      .collection('subscriptions')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Subscription.fromMap(doc.data(), doc.id);
    }).toList();
  });
}
}
