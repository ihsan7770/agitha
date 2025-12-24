import 'dart:convert';

import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;


class DeliveryBoyHomeController extends ChangeNotifier{
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   
Stream<Map<String, dynamic>?> streamCurrentReceivedOrder() async* {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    yield null;
    return;
  }

  // 1️⃣ Stream the delivery boy document
  final boyStream = FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: currentUser.uid)
      .snapshots();

  await for (final snapshot in boyStream) {
    if (snapshot.docs.isEmpty) {
      yield null;
      continue;
    }

    final boy = snapshot.docs.first.data();
    final orderId = boy['order_id'];

    // ❗ No assigned order
    if (orderId == null || orderId.isEmpty) {
      yield null;
      continue;
    }

    // 2️⃣ Stream the specific order document
    final orderStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .snapshots();

    await for (final orderSnap in orderStream) {
      if (!orderSnap.exists) {
        yield null;
        continue;
      }

      final data = orderSnap.data()!;

      // ❌ Skip if delivery-status is cancelled ➜ do not show
      if (data['deliverystatous'] == "cancelled_Order" || data['deliverystatous'] == "order_delivered" || boy['isOrderCancelled']== true ) {
        yield null;
        continue;
      }

      

      // 🔥 Add Firestore document ID manually
      data['id'] = orderSnap.id; 

      yield data;
    }
  }
}









// Total order details show
  /// 🔥 Stream order details using orderId
Stream<Map<String, dynamic>?> streamOrderById(String orderId) {
  return _firestore
      .collection("orders")
      .doc(orderId)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) return null;

    // Extra safety check
    if (snapshot.id != orderId) return null;

    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return data;
  });



  
}

//chnange deliverystatous to delivered
 Future<void> changeOrderStatusToDelivered(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'deliverystatous': 'order_delivered',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order status: $e');
      }
    }
  }

  //create a previous order collection from currect order
Future<void> moveOrderToPreviousCollection(String orderDocId) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print("No delivery boy logged in");
      return;
    }

    final deliveryBoyId = currentUser.uid;

    DocumentSnapshot orderDoc =
        await _firestore.collection("orders").doc(orderDocId).get();

    if (!orderDoc.exists) return;

    final data = orderDoc.data() as Map<String, dynamic>;

    // ensure order is delivered
    if (data['deliverystatous'] != "order_delivered") {
      print("Order status not delivered");
      return;
    }

    // Prevent duplicate move
    if (data['movedToPrevious'] == true) {
      print("Already moved earlier");
      return;
    }

    Map<String, dynamic> previousOrderData = Map.from(data);

    previousOrderData['deliveredAt'] = DateTime.now().toIso8601String();
    previousOrderData['movedToPrevious'] = true;
    previousOrderData['deliveryBoyId'] = deliveryBoyId;

    WriteBatch batch = _firestore.batch();

    batch.set(
      _firestore.collection("previousOrders").doc(orderDocId),
      previousOrderData,
      SetOptions(merge: true),
    );

    batch.update(
      _firestore.collection("orders").doc(orderDocId),
      {
        "movedToPrevious": true,
        "deliveryBoyId": deliveryBoyId,
      },
    );

    await batch.commit();

    print("Order moved to previousOrders successfully");

  } catch (e) {
    print("Error moving order: $e");
    rethrow;
  }
}



//chnange deliverystatous to accepted
 Future<void> changeOrderStatusToAccepted(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'deliverystatous': 'accepted_Order',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order status: $e');
      }
    }
  }

  

//check statous accepted for button 
Stream<bool> checkOrderApprovedStream(String OrderId) {
  return _firestore
      .collection('orders')
      .doc(OrderId)
      .snapshots()
      .map((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('deliverystatous')) {
            return data['deliverystatous'] == 'accepted_Order';
          }
        }
        return false; // default if status missing
      });
}

//to cancel order
 Future<void> changeOrderStatusToCancelled(String orderId,String reason) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'deliverystatous': 'cancelled_Order',
        "cancelReason": reason,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order status: $e');
      }
    }
  }


// for tracking cancelled orders
void setOrderCancelledOrderId() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final query = await FirebaseFirestore.instance
        .collection('deliveryBoys')
        .where('db_userId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return;

    final docId = query.docs.first.id;

    await FirebaseFirestore.instance
        .collection('deliveryBoys')
        .doc(docId)
        .update({
      'isOrderCancelled':true,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    print("ERROR updating order_id: $e");
  }
}




//approved
   Future<void> cancelledOrderReassigned(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'approved',
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating order status: $e');
      }
    }
  }

  //button delivery boy available
void updateAvailability() async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) return;

  final query = await FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: currentUser.uid)
      .get();

  if (query.docs.isNotEmpty) {
    final docId = query.docs.first.id;

    // Update isAvailable
    await FirebaseFirestore.instance
        .collection('deliveryBoys')
        .doc(docId)
        .update({
      'isAvailable': true,
    });

  }
}

void trueandfalseupdateAvailability(bool value) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  final query = await FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: currentUser.uid)
      .get();

  if (query.docs.isNotEmpty) {
    final docId = query.docs.first.id;
    await FirebaseFirestore.instance
        .collection('deliveryBoys')
        .doc(docId)
        .update({'isAvailable': value});
  }
}



Stream<bool> availabilityStream() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return Stream.value(false);

  return FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: currentUser.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data();
          return data['isAvailable'] ?? false;
        }
        return false;
      });
}


//show delivery boy profile details
Stream<DocumentSnapshot<Map<String, dynamic>>?> streamCurrentDeliveryBoy() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: currentUser.uid)
      .limit(1)
      .snapshots()
      .map((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : null);
}

//check is available true to show waiting screen
Stream<bool> streamIsAvailable() {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return Stream.value(false);
  }

  return FirebaseFirestore.instance
      .collection('deliveryBoys')
      .where('db_userId', isEqualTo: currentUser.uid)
      .limit(1)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return false;
        final data = snapshot.docs.first.data();
        return data['isAvailable'] == true;
      });
}

//to set deliverytime
 String? deliveryTime;
  bool isLoadingTime = false;



  /// ✔ Save delivery time to Firestore
  Future<void> setDeliveryTime(String orderId, String time) async {
    await _firestore.collection('orders').doc(orderId).update({
      'deliverytime': time,
    });
    deliveryTime = time;
    notifyListeners();
  }

  /// 🚗 Get Time using Distance Matrix & Save
  Future<void> getTimeFromCurrentLocation({
    required String orderId,
    required double destLat,
    required double destLng,
  }) async {
    try {
      isLoadingTime = true;
      notifyListeners();

      // 🟢 Ask & get location
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      double startLat = pos.latitude;
      double startLng = pos.longitude;

      // 🌍 API Call
      const apiKey = "AIzaSyCrflwq1OFx_mQa10pNLQl5fepBmrKVadg";

      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json"
        "?origins=$startLat,$startLng"
        "&destinations=$destLat,$destLng"
        "&mode=driving"
        "&key=$apiKey"
      );

      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data["status"] == "OK") {
        final element = data["rows"][0]["elements"][0];
        final String duration = element["duration"]["text"];

        await setDeliveryTime(orderId, duration); // Save to Firestore

        print("ETA Saved: $duration");
      }

    } catch (e) {
      if (kDebugMode) print("Error ETA: $e");
    }

    isLoadingTime = false;
    notifyListeners();
  }

  //to show prevous deliveryboy orders

  Stream<List<Map<String, dynamic>>> previousOrdersForDeliveryBoyStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("previousOrders")
      .where("deliveryBoyId", isEqualTo: user.uid)
      // .orderBy("createdAt", descending: true) // latest first
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return {
            "id": doc.id,
            ...doc.data(),
          };
        }).toList();
      });
}







}





  
