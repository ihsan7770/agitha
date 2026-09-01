import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ModelsFoder/CartModel.dart';
import '../ModelsFoder/AddressModel.dart';
import '../ModelsFoder/OrdersModel.dart';

class OrderController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

Stream<List<Map<String, dynamic>>> userOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("orders")
      
      .orderBy("createdAt", descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) {
              final data = doc.data();

              // show only pending, approved, cancelled
              final status = data['status'];
              if (status != "pending" &&
                  status != "approved" &&
                  status != "cancelled") return null;

              // filter items by restaurant
              final items = (data['items'] as List?) ?? [];
              final filteredItems = items.where((item) =>
                  item is Map &&
                  item['restaurantId'] == user.uid).toList();

              if (filteredItems.isEmpty) return null;

              return {
                "id": doc.id,
                ...data,
                "items": filteredItems
              };
            })
            .where((e) => e != null)
            .cast<Map<String, dynamic>>()
            .toList();
      });
}




  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// -------------------------------
  /// FETCH USER PROFILE (name + phone)
  /// -------------------------------
  Stream<Map<String, dynamic>?> currentUserProfileStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection("userprofile")
        .where('loggeduserId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return null;
    });
  }

  /// -------------------------------
  /// FETCH SELECTED ADDRESS
  /// -------------------------------
  Stream<AddressModel?> selectedAddressStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('address')
        .where('userId', isEqualTo: user.uid)
        .where('selectedAddress', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        return AddressModel.fromMap(doc.data(), doc.id);
      }
      return null;
    });
  }

  /// -------------------------------
  /// PLACE ORDER  
  /// (CartItem → OrderItem → Firestore)
  /// -------------------------------
Future<bool> placeOrder({
  required List<CartItem> cartItems,
  required Map<String, dynamic> userProfile,
  required AddressModel selectedAddress,
}) async {
  try {
    _isLoading = true;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) throw "User not logged in";

    List<Map<String, dynamic>> orderItems = cartItems.map((cart) {
      return {
        'dishId':cart.id,
        'restaurantId': cart.restaurantId,
        'companyName': cart.companyName,
        'dishPhoto': cart.dishPhoto,
        'dishName': cart.dishName,
        'price': cart.price,
        'quantity': cart.quantity,
        'totalPrice': cart.totalPrice,
      };
    }).toList();

    Map<String, dynamic> orderData = {
      'userId': user.uid,
      'username': userProfile['username'] ?? '',
      'userphone': userProfile['phonenumber'] ?? '',
      'userimg':userProfile['profileImageUrl'] ?? '',
      'address': selectedAddress.address,
      'housename': selectedAddress.housename,
      'longitude': selectedAddress.longitude,
      'latitude': selectedAddress.latitude,
      'items': orderItems,
      'deliverytime':'',
      'paymentStatus': 'unpaid',
      'cancelReason':'',
      'deliveryBoyId':'',
      'tip':0,
      
      'status': 'pending',
      'deliverystatous': 'pending',
      'createdAt': Timestamp.now()
    };

    await _firestore.collection("orders").add(orderData);

    print("Order placed successfully!");
    return true;                     // 🔥 success response

  } catch (e) {
    print("Error placing order: $e");
    return false;                    // ❌ failed response
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

////show outside cart restourent id
// Future<bool> placeOrder({
//   required List<CartItem> cartItems,
//   required Map<String, dynamic> userProfile,
//   required AddressModel selectedAddress,
// }) async {
//   try {
//     _isLoading = true;
//     notifyListeners();

//     final user = _auth.currentUser;
//     if (user == null) throw "User not logged in";

//     if (cartItems.isEmpty) throw "Cart is empty";

//     // Prepare items
//     List<Map<String, dynamic>> orderItems = cartItems.map((cart) {
//       return {
//         'companyName': cart.companyName,
//         'dishPhoto': cart.dishPhoto,
//         'dishName': cart.dishName,
//         'price': cart.price,
//         'quantity': cart.quantity,
//         'totalPrice': cart.totalPrice,
//       };
//     }).toList();

//     // Prepare order data
//     Map<String, dynamic> orderData = {
//       'userId': user.uid,
//       'username': userProfile['username'] ?? '',
//       'userphone': userProfile['phonenumber'] ?? '',
//       'userimg': userProfile['profileImageUrl'] ?? '',
//       'address': selectedAddress.address,
//       'housename': selectedAddress.housename,
//       'longitude': selectedAddress.longitude,
//       'latitude': selectedAddress.latitude,
//       'items': orderItems,
//       'deliverytime': '',
//       'paymentStatus': 'unpaid',
//       'cancelReason': '',
//       'restaurantId': cartItems.first.restaurantId, // Fixed
//       'status': 'pending',
//       'deliveryStatus': 'pending', // Fixed typo
//       'createdAt': DateTime.now().toIso8601String(),
//     };

//     await _firestore.collection("orders").add(orderData);

//     print("Order placed successfully!");
//     return true;
//   } catch (e, stack) {
//     print("Error placing order: $e\n$stack");
//     return false;
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }







//conform order
Future<void> conformOrder(String foodId) async {
  await _firestore.collection('orders').doc(foodId).update({
    'status': 'approved',
  });
  notifyListeners();
}

//cancel order
Future<void> declineOrder(String foodId) async {
  await _firestore.collection('orders').doc(foodId).update({
    'status': 'rejected',
  });
  notifyListeners();
}
 
 // button statous change
Stream<bool> checkOrderConfromedStream(String foodId) {
  return _firestore
      .collection('orders')
      .doc(foodId)
      .snapshots()
      .map((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('status')) {
            return data['status'] == 'approved';
          }
        }
        return false; // default if status missing
      });
}

//get strem of order 
Stream<QuerySnapshot<Map<String, dynamic>>>? getOrderStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }



//get current user id
 String? _userId;
 String? get userId => _userId;

 OrderController() {
    _fetchUserId();
  }

  /// Fetch and listen for auth state changes
  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;
    notifyListeners();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _userId = user?.uid;
      notifyListeners();
    });
  }


 // to cancel order by user 

Future<bool> cancelOrder(String orderId) async {
  try {
    await _firestore.collection('orders').doc(orderId).update({
      'status': 'cancelled',    
    });

    notifyListeners();
    return true;
  } catch (e) {
    print("Error cancelling order: $e");
    return false;
  }
}

//delete order
Future<void> deleteOrder(String orderId) async {
  try {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .delete();
  } catch (e) {
    debugPrint("Error deleting order: $e");
  }
}

//payment status update
 Future<bool> updatePaymentStatus(String orderId, String paymentStatus,double tip) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection("orders").doc(orderId).update({
        "paymentStatus": paymentStatus,
        "tip":tip,
        
      });

      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _isLoading = false;
      notifyListeners();

      debugPrint("Error updating payment status: $e");
      return false;
    }
  }

  //Delivery statous pending order 
  //

   Stream<List<Map<String, dynamic>>> userPendingOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("orders")
      .orderBy("createdAt", descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        List<Map<String, dynamic>> ordersWithDelivery = [];

        for (var doc in snapshot.docs) {
          final data = doc.data();

          // show only pending, approved, cancelled
          final status = data['deliverystatous'];
          if (status != "assigned" &&
              status != "accepted_Order" &&
              status != "cancelled_Order") continue;

          // filter items by restaurant
          final items = (data['items'] as List?) ?? [];
          final filteredItems = items.where((item) =>
              item is Map &&
              item['restaurantId'] == user.uid).toList();

          if (filteredItems.isEmpty) continue;

          // Fetch delivery boy info for this order
          final deliveryQuery = await FirebaseFirestore.instance
              .collection('deliveryBoys')
              .where('order_id', isEqualTo: doc.id)
              // .orderBy('updatedAt', descending: false)
              .get();

              

          Map<String, dynamic>? deliveryBoy;
          if (deliveryQuery.docs.isNotEmpty) {
              for (var docSnapshot in deliveryQuery.docs) {
             final dbData = docSnapshot.data();
            deliveryBoy = {
              "db_name": dbData['db_name'] ?? "",
              "db_phone": dbData['db_phone'] ?? "",
            };
          }
          }
          ordersWithDelivery.add({
            "id": doc.id,
            ...data,
            "items": filteredItems,
            "deliveryBoy": deliveryBoy, // may be null if not assigned
          });
        }

        return ordersWithDelivery;
      });
}





//show deliverd orders only
 Stream<List<Map<String, dynamic>>> userDeliveredOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("orders")
      .orderBy("createdAt", descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        List<Map<String, dynamic>> ordersWithDelivery = [];

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          // Ensure correct status
          final status = data['deliverystatous'] ?? data['status'] ?? "";
          if (status != "order_delivered") continue;

          final items = List<Map<String, dynamic>>.from(data['items'] ?? []);

          // Filter restaurant items matching current user
          final filteredItems = items
              .where((item) => item['restaurantId'] == user.uid)
              .toList();

          if (filteredItems.isEmpty) continue;

          // Fetch delivery boy details
          Map<String, dynamic>? deliveryBoy;

          try {
            final deliveryQuery = await FirebaseFirestore.instance
                .collection('deliveryBoys')
                .where('orderId', isEqualTo: doc.id)
                .limit(1)
                .get();

            if (deliveryQuery.docs.isNotEmpty) {
              final dbData = deliveryQuery.docs.first.data();
              deliveryBoy = {
                "db_name": dbData['db_name'] ?? dbData['name'] ?? "",
                "db_phone": dbData['db_phone'] ?? dbData['phone'] ?? "",
              };
            }
          } catch (e) {
            print("Delivery boy fetch error: $e");
          }

          ordersWithDelivery.add({
            "id": doc.id,
            ...data,
            "items": filteredItems,
            "deliveryBoy": deliveryBoy,
          });
        }

        return ordersWithDelivery;
      });
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



//show prevousdelivered orders only
 Stream<List<Map<String, dynamic>>> userPreviousDeliveredOrdersStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection("previousOrders")
      .orderBy("createdAt", descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        List<Map<String, dynamic>> ordersWithDelivery = [];

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;

          // ✅ Only delivered orders
          final status = data['deliverystatous'] ?? data['status'] ?? "";
          if (status != "order_delivered") continue;

          final items = List<Map<String, dynamic>>.from(data['items'] ?? []);

          // ✅ Filter restaurant items
          final filteredItems = items
              .where((item) => item['restaurantId'] == user.uid)
              .toList();

          if (filteredItems.isEmpty) continue;

          // ✅ Fetch delivery boy using db_userid == deliveryBoyId
          Map<String, dynamic>? deliveryBoy;
          final deliveryBoyId = data['deliveryBoyId'];

          if (deliveryBoyId != null && deliveryBoyId.toString().isNotEmpty) {
            try {
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
              }
            } catch (e) {
              print("Delivery boy fetch error: $e");
            }
          }

          ordersWithDelivery.add({
            "id": doc.id,
            ...data,
            "items": filteredItems,
            "deliveryBoy": deliveryBoy,
          });
        }

        return ordersWithDelivery;
      });
}

Stream<Map<String, dynamic>?> totalPreviousOrderByIdStream(String orderId) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection("previousOrders")
      .doc(orderId)
      .snapshots()
      .asyncMap((doc) async {
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;

    /// 1️⃣ Check order belongs to current user
    if (data['userId'] != user.uid) return null;

    /// 2️⃣ Ensure delivered order
    final status = data['deliverystatous'] ?? data['status'] ?? "";
    if (status != "order_delivered") return null;

    /// 3️⃣ Get ALL items (no filter)
    final List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(data['items'] ?? []);

    if (items.isEmpty) return null;

    /// 4️⃣ Fetch company using restaurantId (WHERE)
    Map<String, dynamic>? company;
    try {
      final restaurantId = items.first['restaurantId'];

      if (restaurantId != null) {
        final companySnap = await FirebaseFirestore.instance
            .collection('companies')
            .where('userId', isEqualTo: restaurantId)
            .limit(1)
            .get();

        if (companySnap.docs.isNotEmpty) {
          company = companySnap.docs.first.data();
        }
      }
    } catch (e) {
      debugPrint("Company fetch error: $e");
    }

    /// 5️⃣ Fetch delivery boy using db_userId (WHERE)
    Map<String, dynamic>? deliveryBoy;
    try {
      final deliveryBoyId = data['deliveryBoyId'];

      if (deliveryBoyId != null) {
        final dbSnap = await FirebaseFirestore.instance
            .collection('deliveryBoys')
            .where('db_userId', isEqualTo: deliveryBoyId)
            .limit(1)
            .get();

        if (dbSnap.docs.isNotEmpty) {
          deliveryBoy = dbSnap.docs.first.data();
        }
      }
    } catch (e) {
      debugPrint("Delivery boy fetch error: $e");
    }

    return {
      "id": doc.id,
      ...data,
      "items": items,
      "company": company,
      "deliveryBoy": deliveryBoy,
    };
  });
}

Stream<Map<String, dynamic>?> foodByDishIdStream(String dishId) {
  return FirebaseFirestore.instance
      .collection('foodItems')
      .doc(dishId)
      .snapshots()
      .map((doc) {
        if (doc.exists) {
          return doc.data();
        }
        return null;
      });
}

//get number a deliver boy delivered 
Stream<int> completedOrdersCountStream(String deliveryBoyId) {
  return FirebaseFirestore.instance
      .collection('previousOrders')
      .where('deliveryBoyId', isEqualTo: deliveryBoyId)
      .where('deliverystatous', isEqualTo: 'order_delivered')
      .snapshots()
      .map((snapshot) => snapshot.docs.length);
}





}
