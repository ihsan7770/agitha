import 'dart:async';

import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RestaurentDeliveryBoyProvider extends ChangeNotifier {
  final FirebaseFirestore  _firestore = FirebaseFirestore.instance;

/// ✅ Stream only approved delivery boys linked to that company
Stream<List<Map<String, dynamic>>> streamApprovedDeliveryBoysForCompany() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    debugPrint("⚠️ No user logged in, returning empty stream");
    return Stream.value([]);
  }

  return _firestore
      .collection('deliveryBoys')
      .where('working_restaurant_docId', isEqualTo: currentUser.uid)
      .where('status', isEqualTo: 'approved')
      .snapshots()
      .asyncMap((QuerySnapshot snapshot) async {
    List<Map<String, dynamic>> tempList = [];

    for (var doc in snapshot.docs) {
      var deliveryBoyData = doc.data() as Map<String, dynamic>;

      String? userId = deliveryBoyData['db_userId']?.toString();
      String email = 'No email';

      if (userId != null && userId.isNotEmpty) {
        try {
          DocumentSnapshot userDoc =
              await _firestore.collection('Users').doc(userId).get();

          if (userDoc.exists) {
            var userData = userDoc.data() as Map<String, dynamic>;
            email = userData['email']?.toString() ?? 'No email';
          } else {
            email = 'User not found';
          }
        } catch (e) {
          debugPrint("⚠️ Error fetching email for $userId: $e");
        }
      }

      tempList.add({
        'userId': userId,
        'db_name': deliveryBoyData['db_name']?.toString() ?? 'Unknown Delivery Boy',
        'db_location': deliveryBoyData['db_location']?.toString() ?? 'Unknown Location',
        'email': email,
        'status': deliveryBoyData['status'] ?? 'pending',
        'docId': doc.id,
      });
    }

    return tempList;
  });
}


// fech full details of delivery boy
Stream<List<DeliveryBoyModel>> streamDeliveryBoyDetails(String userId) {
  return FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DeliveryBoyModel.fromDoc(doc))
          .toList());
}


//fech availabe delivery boys
Stream<List<DeliveryBoyModel>> streamAvailableDeliveryBoyDetails()
 { final currentUser = FirebaseAuth.instance.currentUser; 
 if (currentUser == null) { debugPrint("⚠️ No user logged in, returning empty stream");
  return Stream.value([]); } 
  return FirebaseFirestore.instance 
  .collection('deliveryBoys')
   .where('working_restaurant_docId', isEqualTo: currentUser.uid)
    .where('status', isEqualTo: 'approved') .where('isAvailable', isEqualTo: true) 
    .snapshots() 
    .map((snapshot) => snapshot.docs 
    .map((doc) => DeliveryBoyModel.fromDoc(doc))
    
     .toList()); }


//order id added to delivery boy
     Future<bool> updateDeliveryBoyOrderId({
  required String deliveryBoyDocId,
  required String orderId,
}) async {
  try {
    await FirebaseFirestore.instance
        .collection('deliveryBoys')
        .doc(deliveryBoyDocId)
        .update({
      'order_id': orderId,   // 🔥 This will store the order id
      'isAvailable': false, 
      "isOrderCancelled":false,       // Optional: set unavailable when order assigned
    
    });

    debugPrint("✅ Order ID updated successfully");
    return true;
  } catch (e) {
    debugPrint("❌ Failed to update Order ID: $e");
    return false;
  }
}


Future<bool> assignOrder(String orderId) async {
  try {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'assigned',
      'deliverystatous': 'assigned',   
    });

   
    return true;
  } catch (e) {
    print("Error Assigned order: $e");
    return false;
  }
}






}
















