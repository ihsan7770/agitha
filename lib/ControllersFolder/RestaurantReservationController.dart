import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestaurantReservationController extends ChangeNotifier {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // final FirebaseAuth _auth = FirebaseAuth.instance;

   
  bool _isLoading = false;
  bool get isLoading => _isLoading;

 

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


// show reservations in restourant side
Stream<List<ReservationModel>> getRestaurantReservationsStream() {
  final user = FirebaseAuth.instance.currentUser;

  // 🔐 Safety check
  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('reservations')
      .where('restaurantId', isEqualTo: user.uid)
      // .orderBy('createdAt', descending: true) // optional
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .where((doc) {
              final data = doc.data();
              final status = data['status'];
              final paymentStatus = data['paymentStatus'];

              // ✅ EXCLUDE paid reservations
              return paymentStatus != 'paid' &&
                  (status == 'pending' ||
                   status == 'approved' ||
                   status == 'cancelled');
            })
            .map(
              (doc) => ReservationModel.fromMap(
                doc.data(),
                doc.id,
              ),
            )
            .toList();
      });
}



Stream<List<ReservationModel>> getPaidReservationsStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("🔹 No user logged in.");
    return const Stream.empty();
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return _firestore
      .collection('reservations')
      .where('restaurantId', isEqualTo: user.uid)
      .where('paymentStatus', isEqualTo: 'paid')
      .snapshots()
      .map((snapshot) {
        List<ReservationModel> reservations = snapshot.docs
            .map((doc) => ReservationModel.fromMap(doc.data(), doc.id))
            // Exclude 'notReached'
            .where((reservation) => reservation.status != 'notReached')
            .where((reservation) => reservation.status != 'ended')
            // Only today's date
            .where((reservation) =>
                reservation.date.year == today.year &&
                reservation.date.month == today.month &&
                reservation.date.day == today.day)
            .toList();

        // Sort by time ascending
        reservations.sort((a, b) => a.time.compareTo(b.time));

        return reservations;
      });
}






// Next day resrevation from the current day  or tomrrow 

Stream<List<ReservationModel>> getTomorrowReservationsStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ No user logged in");
    return const Stream.empty();
  }

  final DateTime now = DateTime.now();

  // 🔹 Tomorrow start & end
  final DateTime tomorrowStart = DateTime(
    now.year,
    now.month,
    now.day + 1,
  );

  final DateTime tomorrowEnd = DateTime(
    now.year,
    now.month,
    now.day + 1,
    23,
    59,
    59,
  );

  return FirebaseFirestore.instance
      .collection('reservations')
      .where('restaurantId', isEqualTo: user.uid)
      .where('paymentStatus', isEqualTo: 'paid')
      .where('status',isEqualTo: 'approved')

      .where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(tomorrowStart),
      )
      .where(
        'date',
        isLessThanOrEqualTo: Timestamp.fromDate(tomorrowEnd),
      )
      .snapshots()
      .map((snapshot) {
        debugPrint("📅 Tomorrow reservations: ${snapshot.docs.length}");

        final List<ReservationModel> reservations = snapshot.docs.map((doc) {
          try {
            return ReservationModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint("⚠️ Parse error in ${doc.id}: $e");
            return null;
          }
        }).whereType<ReservationModel>().toList();

        // ✅ SORT BY TIME (earliest first)
        reservations.sort((a, b) {
          final aTime = DateTime(
            a.date.year,
            a.date.month,
            a.date.day,
           
          );

          final bTime = DateTime(
            b.date.year,
            b.date.month,
            b.date.day,
           
          );

          return aTime.compareTo(bTime);
        });

        debugPrint("⏰ Sorted reservations count: ${reservations.length}");
        return reservations;
      })
      .handleError((error) {
        debugPrint("❌ Stream error: $error");
      });
}

//end 

//upcoming all date reservation
Stream<List<ReservationModel>> getUpcomingReservationsStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ No user logged in");
    return const Stream.empty();
  }

  final DateTime now = DateTime.now();

  // 🔹 Start of today (00:00)
  final DateTime todayStart = DateTime(
    now.year,
    now.month,
    now.day,
  );

  return FirebaseFirestore.instance
      .collection('reservations')
      .where('restaurantId', isEqualTo: user.uid)
      .where('paymentStatus', isEqualTo: 'paid')
      .where('status',isEqualTo: 'approved')

      // ✅ Firestore already filters today + future
      .where(
        'date',
        isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
      )

      .snapshots()
      .map((snapshot) {
        debugPrint("📥 Total fetched: ${snapshot.docs.length}");

        final List<ReservationModel> reservations =
            snapshot.docs.map((doc) {
          try {
            return ReservationModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint("⚠️ Parse error in ${doc.id}: $e");
            return null;
          }
        }).whereType<ReservationModel>().toList();

        // ✅ SORT BY DATE (nearest first)
        reservations.sort((a, b) {
          final aDateTime = DateTime(
            a.date.year,
            a.date.month,
            a.date.day,
          );

          final bDateTime = DateTime(
            b.date.year,
            b.date.month,
            b.date.day,
          );

          return aDateTime.compareTo(bDateTime);
        });

        debugPrint("📤 Upcoming reservations: ${reservations.length}");
        return reservations;
      })
      .handleError((error) {
        debugPrint("❌ Stream error: $error");
      });
}


//end








//get ended reservation stremes by statous ended and notreached

Stream<List<ReservationModel>> getDateEndedReservationsStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ No user logged in");
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('reservations')
      .where('restaurantId', isEqualTo: user.uid)
      .where('paymentStatus', isEqualTo: 'paid')
      .snapshots()
      .map((snapshot) {
        debugPrint("📥 Total fetched: ${snapshot.docs.length}");

        final List<ReservationModel> reservations =
            snapshot.docs.map((doc) {
          try {
            return ReservationModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint("⚠️ Parse error in ${doc.id}: $e");
            return null;
          }
        }).whereType<ReservationModel>()

        // ✅ FILTER ONLY BY STATUS
        .where((r) =>
            r.status == "notReached" ||
            r.status == "ended"||
            r.status =="cancelledAfterPay"
        ).toList();

        // 🔹 OPTIONAL: sort by date (latest first)
        reservations.sort((a, b) {
          return b.date.compareTo(a.date);
        });

        debugPrint("📤 Status filtered reservations: ${reservations.length}");
        return reservations;
      })
      .handleError((error) {
        debugPrint("❌ Stream error: $error");
      });
}





//conform reservation with adding table number
Future<void> conformReservation(
    String reservationId, String tableNo) async {
  _isLoading = true;
  notifyListeners();

  await _firestore.collection('reservations').doc(reservationId).update({
    'status': 'approved',
    'tableno': tableNo,
  });

  _isLoading = false;
  notifyListeners();
}






//cancel reservation
Future<bool> cancelReservationRestaurant(String reservationId) async {
  try {
    await _firestore.collection('reservations').doc(reservationId).update({
      'status': 'rejected',    
    });

    notifyListeners();
    return true;
  } catch (e) {
    print("Error cancelling reservations: $e");
    return false;
  }
}

 // button statous check confromed
Stream<bool> checkReservationConformedStream(String  reservationId) {
  return _firestore
      .collection('reservations')
      .doc(reservationId)
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


//delete reservtion
Future<void> deleteReservation(String reservationId) async {
  try {
    await FirebaseFirestore.instance
        .collection("reservations")
        .doc(reservationId)
        .delete();
  } catch (e) {
    debugPrint("Error deleting reservation: $e");
  }
}

Future<bool> endedReservationRestaurant(String reservationdocId) async {
  try {
    await _firestore.collection('reservations').doc(reservationdocId).update({
      'status': 'ended',    
    });
   return true;
  } catch (e) {
    print("Error end reservations: $e");
    return false;
  }
}

Future<bool> notReachedReservation(String reservationdocId) async {
  try {
    _isLoading = true;
    notifyListeners(); // 🔥 UI update

    await _firestore
        .collection('reservations')
        .doc(reservationdocId)
        .update({
      'status': 'notReached',
    });

    return true;
  } catch (e) {
    debugPrint("❌ Error updating reservation: $e");
    return false;
  } finally {
     _isLoading= false;
    notifyListeners(); // 🔥 stop loading
  }
}


//add bill
// ✅ Latest fetched food items
 List<Map<String, dynamic>> billItems = [];
  List<FoodItemModel> latestFoodItems = [];

  // Add item to bill
 void addItem({
    required String dish,
    required int qty,
    required double price,
  }) {
    billItems.add({
      "dish": dish,
      "qty": qty,
      "price": price ,
    });
    notifyListeners();
  }

  // Remove item from bill
  void removeItem(int index) {
    billItems.removeAt(index);
    notifyListeners();
  }



  // Send bill (your existing logic)
Future<void> sendBill({required String reservationId}) async {
  try {
    if (billItems.isEmpty) {
      throw Exception("No items in bill");
    }

    /// 🔢 Calculate grand total
    double grandTotal = 0;
    for (final item in billItems) {
      final qty = item["qty"] as int;
      final price = item["price"] as double;
      grandTotal += qty * price;
    }

    /// 📦 Prepare food list for Firestore
    final List<Map<String, dynamic>> foodData = billItems.map((item) {
      final qty = item["qty"] as int;
      final price = item["price"] as double;

      return {
        "dish": item["dish"],
        "qty": qty,
        "price": price,
        "total": qty * price,
      };
    }).toList();

    /// 🔥 Update reservation document
    await FirebaseFirestore.instance
        .collection("reservations")
        .doc(reservationId)
        .update({
      "foodData": foodData,
      "status":"ended"
      });

    /// 🧹 Clear local bill after success
    billItems.clear();
    notifyListeners();
  } catch (e) {
    debugPrint("❌ Send bill failed: $e");
    rethrow;
  }
}


  // Stream to fetch food items
  Stream<List<FoodItemModel>> getFoodItemsStream() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("❌ No user logged in");
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('foodItems')
        .where('restaurantId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs
          .map((doc) => FoodItemModel.fromDoc(doc))
          .toList();

      // ✅ store the latest fetched items
      latestFoodItems = items;
      return items;
    });
  }
}



// //add table number reservation ends
// Future<bool> increaseSeat({
//   required String companyId, // userId
//   required List<int> seatCounts, // [2,4,6,8,10]
// }) async {
//   try {
//     final querySnapshot = await _firestore
//         .collection('companies')
//         .where('userId', isEqualTo: companyId)
//         .limit(1)
//         .get();

//     if (querySnapshot.docs.isEmpty) {
//       throw Exception('Company not found for this user');
//     }

//     final docRef = querySnapshot.docs.first.reference;

//     await _firestore.runTransaction((transaction) async {
//       final snapshot = await transaction.get(docRef);
//       final data = snapshot.data()!;

//       int twoSeat   = (data['twoSeat'] ?? 0) as int;
//       int fourSeat  = (data['fourSeat'] ?? 0) as int;
//       int sixSeat   = (data['sixSeat'] ?? 0) as int;
//       int eightSeat = (data['eightSeat'] ?? 0) as int;
//       int tenSeat   = (data['tenSeat'] ?? 0) as int;

//       for (final seat in seatCounts) {
//         switch (seat) {
//           case 2:
//             twoSeat++;
//             break;
//           case 4:
//             fourSeat++;
//             break;
//           case 6:
//             sixSeat++;
//             break;
//           case 8:
//             eightSeat++;
//             break;
//           case 10:
//             tenSeat++;
//             break;
//           default:
//             throw Exception('Invalid seat value: $seat');
//         }
//       }

//       transaction.update(docRef, {
//         'twoSeat': twoSeat,
//         'fourSeat': fourSeat,
//         'sixSeat': sixSeat,
//         'eightSeat': eightSeat,
//         'tenSeat': tenSeat,
//       });
//     });

//     return true;
//   } catch (e) {
//     debugPrint('Seat update error in increaseSeat: $e');
//     return false;
//   }
// }


//ended reservation








