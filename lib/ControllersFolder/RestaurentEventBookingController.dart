import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestaurantEventController extends ChangeNotifier {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

   
  bool _isLoading = false;
  bool get isLoading => _isLoading;

 

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

Stream<List<EventModel>> getRestaurantEventsStream() {
  final user = FirebaseAuth.instance.currentUser;

  // 🔐 Safety check
  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('Events')
      .where('restaurantId', isEqualTo: user.uid)
  
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
              (doc) => EventModel.fromMap(
                doc.data(),
                doc.id,
              ),
            )
            .toList();
      });
}


Future<bool> cancelEventsRestaurant(String eventId) async {
  try {
    await _firestore.collection('Events').doc(eventId).update({
      'status': 'rejected',    
    });

    notifyListeners();
    return true;
  } catch (e) {
    print("Error cancelling Events: $e");
    return false;
  }
}


 // button statous check confromed
Stream<bool> checkEventsConformedStream(String  eventId) {
  return _firestore
      .collection('Events')
      .doc(eventId)
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


// //delete Event
Future<void> deleteEvents(String eventId) async {
  try {
    await FirebaseFirestore.instance
        .collection("Events")
        .doc(eventId)
        .delete();
  } catch (e) {
    debugPrint("Error deleting Events: $e");
  }
}

// //conform reservation with adding table number

Future<void> conformEvent(
   String eventId) async {
  _isLoading = true;
   notifyListeners();

  await _firestore.collection('Events').doc(eventId).update({
    'status': 'approved',
    });
  _isLoading = false;
  notifyListeners();
}

//set not reached when time ended
Future<bool> notReachedEvent(String eventdocId) async {
  try {
    _isLoading = true;
    notifyListeners(); // 🔥 UI update

    await _firestore
        .collection('Events')
        .doc(eventdocId)
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

//current day events
 Stream<List<EventModel>> getPaidEventStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("🔹 No user logged in.");
    return const Stream.empty();
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return _firestore
      .collection('Events')
      .where('restaurantId', isEqualTo: user.uid)
      .where('paymentStatus', isEqualTo: 'paid')
      .snapshots()
      .map((snapshot) {
        List<EventModel> events = snapshot.docs
            .map((doc) => EventModel.fromMap(doc.data(), doc.id))
            // Exclude 'notReached'
            .where((events ) => events .status != 'notReached')
            .where((events ) => events .status != 'ended')
            // Only today's date
            .where((events ) =>
                events .date.year == today.year &&
                events .date.month == today.month &&
                events .date.day == today.day)
            .toList();

        // Sort by time ascending
        events .sort((a, b) => a.time.compareTo(b.time));

        return events;
      });
}


//tommorrow events

Stream<List<EventModel>> getTomorrowEventStream() {
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
      .collection('Events')
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
        debugPrint("📅 Tomorrow events: ${snapshot.docs.length}");

        final List<EventModel> events = snapshot.docs.map((doc) {
          try {
            return EventModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint("⚠️ Parse error in ${doc.id}: $e");
            return null;
          }
        }).whereType<EventModel>().toList();

        // ✅ SORT BY TIME (earliest first)
        events.sort((a, b) {
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

        debugPrint("⏰ Sorted event count: ${events.length}");
        return events;
      })
      .handleError((error) {
        debugPrint("❌ Stream error: $error");
      });
}



// //upcoming all date reservation
Stream<List<EventModel>> getUpcomingEventStream() {
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
      .collection('Events')
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

        final List<EventModel> events =
            snapshot.docs.map((doc) {
          try {
            return EventModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint("⚠️ Parse error in ${doc.id}: $e");
            return null;
          }
        }).whereType<EventModel>().toList();

        // ✅ SORT BY DATE (nearest first)
        events.sort((a, b) {
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

        debugPrint("📤 Upcoming reservations: ${events.length}");
        return events;
      })
      .handleError((error) {
        debugPrint("❌ Stream error: $error");
      });
}

// //get ended reservation stremes by statous ended and notreached

Stream<List<EventModel>> getDateEndedEventStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ No user logged in");
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('Events')
      .where('restaurantId', isEqualTo: user.uid)
      .where('paymentStatus', isEqualTo: 'paid')
      .snapshots()
      .map((snapshot) {
        debugPrint("📥 Total fetched: ${snapshot.docs.length}");

        final List<EventModel> events =
            snapshot.docs.map((doc) {
          try {
            return EventModel.fromMap(doc.data(), doc.id);
          } catch (e) {
            debugPrint("⚠️ Parse error in ${doc.id}: $e");
            return null;
          }
        }).whereType<EventModel>()

        // ✅ FILTER ONLY BY STATUS
        .where((r) =>
            r.status == "notReached" ||
            r.status == "ended"||
            r.status =="cancelledAfterPay"
        ).toList();

        // 🔹 OPTIONAL: sort by date (latest first)
        events.sort((a, b) {
          return b.date.compareTo(a.date);
        });

        debugPrint("📤 Status filtered reservations: ${events.length}");
        return events;
      })
      .handleError((error) {
        debugPrint("❌ Stream error: $error");
      });

}


Stream<EventModel?> getSingleEventStream(String eventId) {
  return FirebaseFirestore.instance
      .collection("Events")
      .doc(eventId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    return EventModel.fromMap(doc.data()!, doc.id);
  });
}




//billing 



  // ---------------- SAFE HELPERS ----------------
  String safeString(String? value) => value?.trim() ?? "";
  int safeInt(dynamic value) => int.tryParse(value?.toString() ?? "") ?? 0;
  double safeDouble(dynamic value) =>
      double.tryParse(value?.toString() ?? "") ?? 0.0;
  List safeList(List? value) => value ?? [];

  // ---------------- SEND BILL ----------------
  Future<void> sendEventBill({
    required String? userId, // 👈 customer id

    String? eventId,
    String? eventType,
    String? noGuests,

    String? baseDecorationAmount,
    int? extraDecorationPrice,
    double? totalDecorationAmount,

    List<Map<String, dynamic>>? foodItems,
    double? totalFoodAmount,

    List<dynamic>? cakes,
    String? cakeType,
    String? cakeDecorationPrice,

    List<dynamic>? bakery,

    double? grandTotal,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      /// 🔐 CURRENT USER = RESTAURANT
      final String restaurantId = _auth.currentUser?.uid ?? "";

      /// 🎂 Cake Total
      double totalCakeAmount = 0;
      for (var cake in safeList(cakes)) {
        totalCakeAmount += safeDouble(cake["calculatedPrice"]);
      }
      totalCakeAmount += safeDouble(cakeDecorationPrice);

      /// 🧁 Bakery Total
      double totalBakeryAmount = 0;
      for (var item in safeList(bakery)) {
        totalBakeryAmount += safeDouble(item["price"]);
      }

      await _firestore.collection("event_bill").add({
        // 👤 IDS
        "userId": safeString(userId),              // customer
        "restaurantId": restaurantId,              // current user

        // 🎉 Event
        "eventId": safeString(eventId),
        "eventType": safeString(eventType),
        "noGuests": safeInt(noGuests),

        // 🎀 Decoration
        "baseDecorationAmount": safeDouble(baseDecorationAmount),
        "extraDecorationPrice": safeInt(extraDecorationPrice),
        "totalDecorationAmount": safeDouble(totalDecorationAmount),

        // 🍔 Food
        "foodItems": safeList(foodItems),
        "totalFoodAmount": safeDouble(totalFoodAmount),

        // 🎂 Cake
        "cakes": safeList(cakes),
        "cakeType": safeString(cakeType),
        "cakeDecorationPrice": safeDouble(cakeDecorationPrice),
        "totalCakeAmount": totalCakeAmount,

        // 🧁 Bakery
        "bakeryItems": safeList(bakery),
        "totalBakeryAmount": totalBakeryAmount,

        // 💰 Final
        "grandTotal": safeDouble(grandTotal),

        // 🕒 Meta
        "status": "ended",
        "createdAt": FieldValue.serverTimestamp(),
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

Future<void> conformEndEvent(
   String eventId) async {
  _isLoading = true;
   notifyListeners();

  await _firestore.collection('Events').doc(eventId).update({
    'status': 'ended',
    });
  _isLoading = false;
  notifyListeners();
}




//prevous more event details

Stream<QuerySnapshot<Map<String, dynamic>>> getEventBillStream(
    String eventId) {
  return FirebaseFirestore.instance
      .collection('event_bill')
      .where('eventId', isEqualTo: eventId) // 👈 THIS LINE
      .limit(1)
      .snapshots();
}





}








