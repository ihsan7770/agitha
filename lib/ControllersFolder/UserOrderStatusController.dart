import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';



class UserOrderStatusProvider extends ChangeNotifier {

Stream<List<Map<String, dynamic>>> currentUserOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("orders")
      .where("userId", isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        final orders = snapshot.docs.map((doc) {
          return {
            "id": doc.id,
            ...doc.data(),
          };
        }).toList();

        // ✅ Sort locally (latest first)
        orders.sort((a, b) {
          final aTime = a['createdAt'] as Timestamp?;
          final bTime = b['createdAt'] as Timestamp?;
          return (bTime?.compareTo(aTime!) ?? 0);
        });

        // ✅ Return only the latest order
        return orders.take(1).toList();
      });
}
//check any orders active or not 

Stream<bool> hasActiveOrderStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return Stream.value(false);
  }

  return FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: user.uid)
      .where('deliverystatous', whereIn: [
        'pending',
        'assigned',
        'accepted_Order',
        'cancelled_Order',
      ])
      .snapshots()
      .map((snapshot) {
        final activeOrders = snapshot.docs.where((doc) {
          final paymentStatus = doc['paymentStatus'];
          return paymentStatus == 'COD' || paymentStatus == 'paid';
        }).toList();

        print("Active orders count: ${activeOrders.length}");
        return activeOrders.isNotEmpty;
      });
}










  



  //currentuser orderstrem as not delivered
Stream<List<Map<String, dynamic>>> notdeliveredcurrentUserOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("orders")
      .where("userId", isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        final orders = snapshot.docs
            .map((doc) => {
                  "id": doc.id,
                  ...doc.data(),
                })
            // ✅ Only active (not delivered & not cancelled)
            .where((order) =>
                order["deliverystatous"] != "order_delivered" &&
                order["status"] != "cancelled"&&
                order["status"] != "rejected"
                
                )
            .toList();

        // 🔽 Sort latest first
        orders.sort((a, b) {
          final aTime = a['createdAt'] as Timestamp;
          final bTime = b['createdAt'] as Timestamp;
          return bTime.compareTo(aTime);
        });

        // ✅ LIMIT TO 1 (latest only)
        return orders.isNotEmpty ? [orders.first] : [];
      });
}





  //restourent feching 

  Stream<Map<String, dynamic>?> singleRestaurantDetails(String restaurantId) {
  return FirebaseFirestore.instance
      .collection("companies")
      .where("userId", isEqualTo: restaurantId)
      .limit(1)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return null;
        final doc = snapshot.docs.first;
        return {"id": doc.id, ...doc.data()};
      });
}

//delivery boy feching

Stream<Map<String, dynamic>?> deliveryBoyForOrderStream(String orderId) {
  final ordersRef = FirebaseFirestore.instance.collection("orders");
  final deliveryBoysRef =
      FirebaseFirestore.instance.collection("deliveryBoys");

  return ordersRef.doc(orderId).snapshots().asyncMap((orderDoc) async {
    if (!orderDoc.exists) return null;

    final orderData = orderDoc.data();
    if (orderData == null) return null;

    // Check order status
    if (orderData["deliverystatous"] != "accepted_Order") return null;

    // Find delivery boy assigned to this order
    final deliveryQuery = await deliveryBoysRef
        .where("order_id", isEqualTo: orderId)
        .limit(1)
        .get();

    if (deliveryQuery.docs.isEmpty) return null;

    final dbDoc = deliveryQuery.docs.first;
    final dbData = dbDoc.data();

    return {
      "deliveryBoyId": dbData["db_userId"] ?? "",
      "db_name": dbData["db_name"] ?? "Unknown",
      "db_phone": dbData["db_phone"] ?? "-",
      // "isAvailable": dbData["isAvailable"] ?? false,
    };
  });
}

//check order delivered
Stream<bool> streamOrderDelivered(String orderId) {
  return FirebaseFirestore.instance
      .collection("orders")
      .doc(orderId)
      .snapshots()
      .map((snap) {
        if (!snap.exists) return false;
        return snap.data()?['deliverystatous'] == 'order_delivered';
      });
}


//current user prevous order streme
Stream<List<Map<String, dynamic>>> previousUserOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("previousOrders")
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .asyncMap((snapshot) async {
        List<Map<String, dynamic>> orders = [];

        final Map<String, Map<String, dynamic>> deliveryBoyCache = {};
        final Map<String, Map<String, dynamic>> restaurantCache = {};

        for (var doc in snapshot.docs) {
          final data = doc.data();

          final status =
              data['deliverystatous'] ?? data['status'] ?? "assigned";
          if (status != "order_delivered") continue;

          final items =
              List<Map<String, dynamic>>.from(data['items'] ?? []);

          final restaurantId =
              items.isNotEmpty ? items.first['restaurantId'] : null;
          final deliveryBoyId = data['deliveryBoyId'];

          Map<String, dynamic>? deliveryBoy;
          Map<String, dynamic>? restaurant;

          /// 🔹 DELIVERY BOY
          if (deliveryBoyId != null && deliveryBoyId.toString().isNotEmpty) {
            if (deliveryBoyCache.containsKey(deliveryBoyId)) {
              deliveryBoy = deliveryBoyCache[deliveryBoyId];
            } else {
              final dbQuery = await FirebaseFirestore.instance
                  .collection('deliveryBoys')
                  .where('db_userId', isEqualTo: deliveryBoyId)
                  .limit(1)
                  .get();

              if (dbQuery.docs.isNotEmpty) {
                final dbData = dbQuery.docs.first.data();
                deliveryBoy = {
                  "db_name": dbData['db_name'] ?? "",
                  "db_phone": dbData['db_phone'] ?? "",
                };
                deliveryBoyCache[deliveryBoyId] = deliveryBoy;
              }
            }
          }

          /// 🔹 RESTAURANT
          if (restaurantId != null && restaurantId.toString().isNotEmpty) {
            if (restaurantCache.containsKey(restaurantId)) {
              restaurant = restaurantCache[restaurantId];
            } else {
              final restQuery = await FirebaseFirestore.instance
                  .collection('companies')
                  .where('userId', isEqualTo: restaurantId)
                  .limit(1)
                  .get();

              if (restQuery.docs.isNotEmpty) {
                final restData = restQuery.docs.first.data();
                restaurant = {
                  "restaurantName": restData['restaurantName'] ?? "",
                  "location": restData['location'] ?? "",
                  "restaurantImageUrl":
                      restData['restaurantImageUrl'] ?? "",
                };
                restaurantCache[restaurantId] = restaurant;
              }
            }
          }

          orders.add({
            "id": doc.id,
            ...data,
            "items": items,
            "deliveryBoy": deliveryBoy,
            "restaurant": restaurant,
          });
        }

        /// ✅ SORT: Latest order first
        orders.sort((a, b) {
          final aTime = a['createdAt'];
          final bTime = b['createdAt'];

          if (aTime is Timestamp && bTime is Timestamp) {
            return bTime.compareTo(aTime);
          }
          return 0;
        });

        /// ✅ OPTION 1: Return all previous orders (sorted)
        return orders;

        /// ✅ OPTION 2: Return only latest order
        // return orders.isNotEmpty ? [orders.first] : [];
      });
}




// //sample fech
// Stream<List<Map<String, dynamic>>> previousUserOrdersStream() {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     return Stream.value([]);
//   }

//   return FirebaseFirestore.instance
//       .collection('previousOrders')
//       .where('userId', isEqualTo: user.uid)
//       // .orderBy('createdAt', descending: true)
//       .snapshots()
//       .map((snapshot) {
//         return snapshot.docs.map((doc) {
//           return {
//             'id': doc.id,
//             ...doc.data(),
//           };
//         }).toList();
//       });
// }














  
}


