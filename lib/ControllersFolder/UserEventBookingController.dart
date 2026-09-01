import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/ModelsFoder/CakeDecorationModel.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/ModelsFoder/DecorationModel.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserEventProvider extends ChangeNotifier {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // final FirebaseAuth _auth = FirebaseAuth.instance;

   
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  //create event collection


  Future<void> addEvent(
    EventModel  event,
    BuildContext context,
  ) async {
    try {
      // 🔹 START LOADING
      _isLoading = true;
      notifyListeners();

      // 🔹 Get current user
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      // 🔹 Query userprofile by loggeduserId
      final userQuery = await FirebaseFirestore.instance
          .collection('userprofile')
          .where('loggeduserId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception("User profile not found");
      }

      final userData = userQuery.docs.first.data();

      // 🔹 Merge reservation + user data
      final eventData = event.toMap()
        ..addAll({
          'userId': user.uid,
          'userName': userData['username'],
          'phoneNumber': userData['phonenumber'],
          'createdAt': FieldValue.serverTimestamp(),
        });

      // 🔹 Store reservation
      await FirebaseFirestore.instance
          .collection('Events')
          .add(eventData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event added successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      // 🔹 STOP LOADING (ALWAYS)
      _isLoading = false;
      notifyListeners();
    }
  }

//take resrtourent current details for deposit amount
  Stream<List<CompanyRegistrationModel>> getDecorationAmountStream(String restaurantId) {
  return FirebaseFirestore.instance
      .collection('companies')
      .where('userId', isEqualTo: restaurantId)
      // .orderBy('reservationDate', descending: false) // optional, order by date
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) =>CompanyRegistrationModel.fromMap(doc.data()))
          .toList());
}

//cnacel event

//cancel reservation by user
Future<bool> cancelBookedEvent(String eventId) async {
  try {
    await _firestore.collection('Events').doc(eventId).update({
      'status': 'cancelled',    
    });

    notifyListeners();
    return true;
  } catch (e) {
    print("Error cancelling reservations: $e");
    return false;
  }
}


 //get user id and with that id fech event from collection
Stream<EventModel?> userLatestEventStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('Events')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return null;

        final docs = snapshot.docs;

        // 🔥 Sort locally by createdAt
        docs.sort((a, b) {
          final aTime =
              (a['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
          final bTime =
              (b['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
          return bTime.compareTo(aTime);
        });

        final latestDoc = docs.first;

        return EventModel.fromMap(
          latestDoc.data(),
          latestDoc.id,
        );
      });
}

 //get reservation details in payment page
Stream<DocumentSnapshot<Map<String, dynamic>>> eventStreamInPaymentPage(
    String eventId) {
  return FirebaseFirestore.instance
      .collection('Events')
      .doc(eventId)
      .snapshots();
}


//update payment status after payment
 Future<bool> updatePaymentStatus(String reservationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection("Events").doc(reservationId).update({
        "paymentStatus": "paid",
        
        
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


 // Stream to check slot availability


  /// SLOT OVERLAP CHECK
Stream<bool> checkEventSlotAvailability({
  required String eventId,
  required DateTime selectedDate,
  required TimeOfDay selectedTime,
  required int duration, // in minutes
  // String? excludeReservationId,
}) {
  debugPrint("🔹 Checking slot for restaurant: $eventId");
  debugPrint("🔹 Selected Date: $selectedDate");
  debugPrint("🔹 Selected Time: ${selectedTime.hour}:${selectedTime.minute}");
  debugPrint("🔹 Duration (minutes): $duration");

  return FirebaseFirestore.instance
      .collection('Events')
      .where('restaurantId', isEqualTo: eventId) // single filter → no index
      .where('paymentStatus', isEqualTo: 'paid')
       .where('status', isEqualTo: 'approved')
      .snapshots()
      .map((snapshot) {
        debugPrint("📥 Snapshot received: ${snapshot.docs.length} event found");

        final events = snapshot.docs
            .map((doc) {
              final e = ReservationModel.fromMap(doc.data(), doc.id);
              debugPrint("Event ID: ${e.id}, Date: ${e.date}, Time: ${e.time}, Duration: ${e.duration}");
              return e;
            })
            .toList();

        final DateTime selectedStart = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        final DateTime selectedEnd = selectedStart.add(Duration(minutes: duration));

        debugPrint("▶ Selected Slot Start: $selectedStart");
        debugPrint("▶ Selected Slot End: $selectedEnd");

        for (final event in  events) {
          // Skip the same reservation if editing
          // if (excludeReservationId != null && reservation.id == excludeReservationId) {
          //   debugPrint("⏭ Skipping same reservation ID: ${reservation.id}");
          //   continue;
          // }

          final resStart = DateTime(
            event.date.year,
            event.date.month,
            event.date.day,
            event.time.toDate().hour,
            event.time.toDate().minute,
          );

          final resEnd = resStart.add(Duration(minutes: event.duration));

          debugPrint("🧾 Comparing with Event ID: ${event.id}");
          debugPrint("▶ Event Start: $resStart");
          debugPrint("▶ Event End: $resEnd");

          if (selectedStart.isBefore(resEnd) && selectedEnd.isAfter(resStart)) {
            debugPrint("❌ OVERLAP FOUND with EventID: ${event.id}");
            return false; // Slot is booked
          }
        }

        debugPrint("✅ No overlap found — Slot is available");
        return true;
      })
      .handleError((error) {
        debugPrint("❌ Firestore stream error: $error");
      });
}
  

//user present reservation 
Stream<List<Map<String, dynamic>>> userEventWithCompanyStream() {
  final eventsRef =
      FirebaseFirestore.instance.collection("Events");
  final companyRef =
      FirebaseFirestore.instance.collection("companies");

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ User not logged in");
    return const Stream.empty();
  }

  debugPrint("✅ Current User ID: ${user.uid}");

  return eventsRef
      .where("userId", isEqualTo: user.uid)
      .where("paymentStatus", isEqualTo: "paid")
      .where("status", isEqualTo: "approved")

      // ✅ FILTER STATUS HERE (ended & notReached will NOT come)
      // .where("status", whereNotIn: ["ended", "notReached"])

      .snapshots()
      .asyncMap((eventSnap) async {

    debugPrint("📦 events fetched: ${eventSnap.docs.length}");

    if (eventSnap.docs.isEmpty) {
      debugPrint("⚠️ No events found");
      return [];
    }

    List<Map<String, dynamic>> tempResult = [];
    final now = DateTime.now();

    for (final eventDoc in eventSnap.docs) {
      final eventData = eventDoc.data();

      // ---------------- Validate date & time ----------------
      if (eventData ["date"] == null || eventData ["date"] is! Timestamp ||
          eventData ["time"] == null || eventData ["time"] is! Timestamp) {
        continue;
      }

      final DateTime eventDate =
          (eventData["date"] as Timestamp).toDate().toLocal();

      final DateTime evenTime =
          (eventData["time"] as Timestamp).toDate().toLocal();

      // ---------------- Calculate start & end datetime ----------------
      final DateTime startDateTime = DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
        eventDate.hour,
        eventDate.minute,
      );

      final int durationMinutes = eventData["duration"] ?? 60;
      final DateTime endDateTime =
          startDateTime.add(Duration(minutes: durationMinutes));

      // ---------------- Skip expired reservations ----------------
      if (endDateTime.isBefore(now)) {
        continue;
      }

      final String restaurantUserId = eventData["restaurantId"];

      // ---------------- Get Company Data ----------------
      final companyQuery = await companyRef
          .where("userId", isEqualTo: restaurantUserId)
          .limit(1)
          .get();

      if (companyQuery.docs.isEmpty) continue;

      final companyData = companyQuery.docs.first.data();

      // ---------------- Add to result ----------------
      tempResult.add({
        "eventId": eventDoc.id,
        "restaurantId": restaurantUserId,
        "restaurantName": companyData["restaurantName"] ?? "",
        "location": companyData["location"] ?? "",
        "image": companyData["logoUrl"] ?? "",
        "date": eventData["date"],
        "time": eventData["time"],
        "decorationType": eventData["decorationType"],
        "guests": eventData["guests"],
        "duration": durationMinutes,
        "depositAmount": eventData["depositAmount"],
        "eventType": eventData["eventType"],
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
      });
    }

    // ---------------- Sort by upcoming first ----------------
    tempResult.sort((a, b) {
      final DateTime startA = a["startDateTime"] as DateTime;
      final DateTime startB = b["startDateTime"] as DateTime;
      return startA.compareTo(startB);
    });

    debugPrint("🎯 Final Result Count: ${tempResult.length}");

    return tempResult;
  });
}




//cancel event by user after payment
Future<bool> canceleventAfterPay(String eventId) async {
  try {
    _isLoading = true;
    notifyListeners();
    await _firestore.collection('Events').doc(eventId).update({
      'status': 'cancelledAfterPay',    
    });

    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
     _isLoading = false;
    notifyListeners();
    print("Error cancelling event: $e");
    return false;
  }
}

//user ended event streme
Stream<List<Map<String, dynamic>>> userPasteventStream() {
  final eventRef =
      FirebaseFirestore.instance.collection("Events");
  final companyRef =
      FirebaseFirestore.instance.collection("companies");

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ User not logged in");
    return const Stream.empty();
  }

  return eventRef 
      .where("userId", isEqualTo: user.uid)

      // ✅ Only ended & notReached
      .where("status", whereIn: ["ended", "notReached","cancelledAfterPay"])

      .snapshots()
      .asyncMap((eventSnap) async {
        if (eventSnap.docs.isEmpty) return [];

        List<Map<String, dynamic>> tempResult = [];

        for (final eventDoc in eventSnap.docs) {
          final eventData = eventDoc.data();
          final String restaurantUserId = eventData["restaurantId"];

          // ---------------- Get Company Data ----------------
          final companyQuery = await companyRef
              .where("userId", isEqualTo: restaurantUserId)
              .limit(1)
              .get();

          if (companyQuery.docs.isEmpty) continue;

          final companyData = companyQuery.docs.first.data();

          tempResult.add({
            "eventId": eventDoc.id,
            "restaurantId": restaurantUserId,
            "restaurantName": companyData["restaurantName"] ?? "",
            "location": companyData["location"] ?? "",
            "image": companyData["logoUrl"] ?? "",
            "date": eventData["date"],
            "time": eventData["time"],
           
            "guests": eventData["guests"],
            "duration": eventData["duration"],
            "depositAmount": eventData["depositAmount"],
            "eventType":eventData["eventType"],
            "foodData": eventData["foodData"] ?? [],
            "status": eventData["status"],
            "updatedAt": eventData["updatedAt"], // Timestamp
          });
        }

        // --------------------------------------------------
        // ✅ LOCAL SORT: Latest updated first
        // --------------------------------------------------
        tempResult.sort((a, b) {
          final Timestamp? t1 = a["updatedAt"];
          final Timestamp? t2 = b["updatedAt"];

          if (t1 == null && t2 == null) return 0;
          if (t1 == null) return 1;
          if (t2 == null) return -1;

          return t2.compareTo(t1); // descending (latest first)
        });

        return tempResult;
      });
}

Stream<List<FoodItemModel>> streamUserCakeItems(String restaurantId) {
  return _firestore
      .collection('foodItems')
      .where('category', isEqualTo: 'Cake')
      .where('restaurantId', isEqualTo: restaurantId) // ✅ passed as parameter
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => FoodItemModel.fromDoc(doc))
            .toList();
      });
}


Stream<List<FoodItemModel>> streamUserbakeryItems(String restaurantId) {
  return _firestore
      .collection('foodItems')
      .where('category', isEqualTo: 'Bakery')
      .where('restaurantId', isEqualTo: restaurantId) // ✅ passed as parameter
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => FoodItemModel.fromDoc(doc))
            .toList();
      });
}


///fech decoration by restaurant id
     List<DecorationModel> decorations = [];

  DecorationModel? selectedDecoration;

  // fetch by restaurant
Future<void> fetchDecorationsByRestaurant(String restauratId) async {
  _isLoading = true;
  notifyListeners();

  final snapshot = await FirebaseFirestore.instance
      .collection('decorations')
      .where('restauratId', isEqualTo: restauratId)
      .get();

  decorations = snapshot.docs
      .map((doc) => DecorationModel.fromMap(doc.data(), doc.id))
      .toList();

  _isLoading = false;
  notifyListeners();
}


  // ✅ select decoration by id
void selectDecorationById(String decorationId) {
  selectedDecoration = decorations.firstWhere(
    (d) => d.docId == decorationId,
  );
  notifyListeners();
}


//show cakw decorartion details in user event booking page
Stream<List<CakeDecorationModel>> cakeDecorationsStream(String restaurantId) {
  return FirebaseFirestore.instance
      .collection('cakeDecorations')
      .where('restauratId', isEqualTo: restaurantId)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return CakeDecorationModel.fromMap(
        doc.data(),
        doc.id,
      );
    }).toList();
  });
}

//food strem 
Stream<List<FoodItemModel>> restaurantFoodStream(String restaurantId) {
  return FirebaseFirestore.instance
      .collection('foodItems')
      .where('restaurantId', isEqualTo: restaurantId)
      .where('category', whereIn: ['Special', 'Normal',])
      .snapshots()
      .map(
        (QuerySnapshot<Map<String, dynamic>> snapshot) =>
            snapshot.docs.map(FoodItemModel.fromDoc).toList(),
      );
}


Stream<List<FoodItemModel>> restaurantDrinksStream(String restaurantId) {
  return FirebaseFirestore.instance
      .collection('foodItems')
      .where('restaurantId', isEqualTo: restaurantId)
      .where('category', isEqualTo: 'Drinks')
      .snapshots()
      .map(
        (QuerySnapshot<Map<String, dynamic>> snapshot) =>
            snapshot.docs.map(FoodItemModel.fromDoc).toList(),
      );
}

Stream<EventModel?> getUserSingleEventStream(String eventId) {
  return FirebaseFirestore.instance
      .collection("Events")
      .doc(eventId)
      .snapshots()
      .map((doc) {
    if (!doc.exists) return null;
    return EventModel.fromMap(doc.data()!, doc.id);
  });
}

Stream<CompanyRegistrationModel?> getUserSingleEventCompanyDetailsStream(String resId) {
  return FirebaseFirestore.instance
      .collection("companies")
      .where('userId', isEqualTo: resId)
      .limit(1)
      .snapshots()
      .map((querySnapshot) {
        if (querySnapshot.docs.isEmpty) {
          return null;
        }
        return CompanyRegistrationModel.fromMap(
          querySnapshot.docs.first.data(),
        );
      });
}

// UserSide bill detials
Stream<QuerySnapshot<Map<String, dynamic>>> getUserEventBillStream(
    String eventId) {
  return FirebaseFirestore.instance
      .collection('event_bill')
      .where('eventId', isEqualTo: eventId) // 👈 THIS LINE
      .limit(1)
      .snapshots();
}




}











