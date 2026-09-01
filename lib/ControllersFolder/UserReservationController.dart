import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';

class UserReservationProvider extends ChangeNotifier {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // final FirebaseAuth _auth = FirebaseAuth.instance;

   
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  //create reservation collection


  Future<void> addReservation(
    ReservationModel reservation,
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
      final reservationData = reservation.toMap()
        ..addAll({
          'userId': user.uid,
          'userName': userData['username'],
          'phoneNumber': userData['phonenumber'],
          'createdAt': FieldValue.serverTimestamp(),
        });

      // 🔹 Store reservation
      await FirebaseFirestore.instance
          .collection('reservations')
          .add(reservationData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reservation added successfully")),
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



  //get user id and with that id fech reservation from collection
Stream<ReservationModel?> userLatestReservationStream() {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('reservations')
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

        return ReservationModel.fromMap(
          latestDoc.data(),
          latestDoc.id,
        );
      });
}


//cancel reservation by user
Future<bool> cancelReservation(String reservationId) async {
  try {
    await _firestore.collection('reservations').doc(reservationId).update({
      'status': 'cancelled',    
    });

    notifyListeners();
    return true;
  } catch (e) {
    print("Error cancelling reservations: $e");
    return false;
  }
}


//cancel reservation by user
Future<bool> cancelReservationAfterPay(String reservationId) async {
  try {
    _isLoading = true;
    notifyListeners();

    await _firestore.collection('reservations').doc(reservationId).update({
      'status': 'cancelledAfterPay',
    });

    _isLoading = false;
    notifyListeners();
    return true;
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    print("Error cancelling reservations: $e");
    return false;
  }
}


 //get reservation details in payment page
Stream<DocumentSnapshot<Map<String, dynamic>>> reservationStreamInPaymentPage(
    String reservationId) {
  return FirebaseFirestore.instance
      .collection('reservations')
      .doc(reservationId)
      .snapshots();
}

// get company seat details by restourent id

 Stream<List<CompanyRegistrationModel>> getSeatsStream(String restaurantId) {
  return FirebaseFirestore.instance
      .collection('companies')
      .where('userId', isEqualTo: restaurantId)
      // .orderBy('reservationDate', descending: false) // optional, order by date
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) =>CompanyRegistrationModel.fromMap(doc.data()))
          .toList());
}


//update payment status after payment
 Future<bool> updatePaymentStatus(String reservationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection("reservations").doc(reservationId).update({
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

 
   
// Stream<bool> checkSlotAvailability({
//   required String restaurantId,
//   required DateTime selectedDate,
//   required TimeOfDay selectedTime,
//   required int duration, // in minutes
//   // String? excludeReservationId,
// }) {
//   debugPrint("🔹 Checking slot for restaurant: $restaurantId");
//   debugPrint("🔹 Selected Date: $selectedDate");
//   debugPrint("🔹 Selected Time: ${selectedTime.hour}:${selectedTime.minute}");
//   debugPrint("🔹 Duration (minutes): $duration");

//   return FirebaseFirestore.instance
//       .collection('reservations')
//       .where('restaurantId', isEqualTo: restaurantId) // single filter → no index
//       .where('paymentStatus', isEqualTo: 'paid')
//       .snapshots()
//       .map((snapshot) {
//         debugPrint("📥 Snapshot received: ${snapshot.docs.length} reservations found");

//         final reservations = snapshot.docs
//             .map((doc) {
//               final r = ReservationModel.fromMap(doc.data(), doc.id);
//               debugPrint("📄 Reservation ID: ${r.id}, Date: ${r.date}, Time: ${r.time}, Duration: ${r.duration}");
//               return r;
//             })
//             .toList();

//         final DateTime selectedStart = DateTime(
//           selectedDate.year,
//           selectedDate.month,
//           selectedDate.day,
//           selectedTime.hour,
//           selectedTime.minute,
//         );

//         final DateTime selectedEnd = selectedStart.add(Duration(minutes: duration));

//         debugPrint("▶ Selected Slot Start: $selectedStart");
//         debugPrint("▶ Selected Slot End: $selectedEnd");

//         for (final reservation in reservations) {
//           // Skip the same reservation if editing
//           // if (excludeReservationId != null && reservation.id == excludeReservationId) {
//           //   debugPrint("⏭ Skipping same reservation ID: ${reservation.id}");
//           //   continue;
//           // }

//           final resStart = DateTime(
//             reservation.date.year,
//             reservation.date.month,
//             reservation.date.day,
//             reservation.time.toDate().hour,
//             reservation.time.toDate().minute,
//           );

//           final resEnd = resStart.add(Duration(minutes: reservation.duration));

//           debugPrint("🧾 Comparing with Reservation ID: ${reservation.id}");
//           debugPrint("▶ Reservation Start: $resStart");
//           debugPrint("▶ Reservation End: $resEnd");

//           if (selectedStart.isBefore(resEnd) && selectedEnd.isAfter(resStart)) {
//             debugPrint("❌ OVERLAP FOUND with reservation ID: ${reservation.id}");
//             return false; // Slot is booked
//           }
//         }

//         debugPrint("✅ No overlap found — Slot is available");
//         return true;
//       })
//       .handleError((error) {
//         debugPrint("❌ Firestore stream error: $error");
//       });
// }


//


Stream<Map<int, int>> checkSlotAvailabilityWithSeats({
  required String restaurantId,
  required DateTime selectedDate,
  required TimeOfDay selectedTime,
  required int duration, // in minutes
  String? excludeReservationId,
}) {
  debugPrint("🔹 Checking slot for restaurant: $restaurantId");
  debugPrint("🔹 Selected Date: $selectedDate");
  debugPrint("🔹 Selected Time: ${selectedTime.hour}:${selectedTime.minute}");
  debugPrint("🔹 Duration (minutes): $duration");

  final reservationsStream = FirebaseFirestore.instance
      .collection('reservations')
      .where('restaurantId', isEqualTo: restaurantId)
      .where('paymentStatus', isEqualTo: 'paid')
      .where('status', isEqualTo: 'approved')

      .snapshots();

  final companyStream = FirebaseFirestore.instance
      .collection('companies')
      .where('userId', isEqualTo: restaurantId)
      .limit(1)
      .snapshots();

  return StreamZip([reservationsStream, companyStream]).map((snapshots) {
    final reservationSnapshot = snapshots[0] as QuerySnapshot;
    final companySnapshot = snapshots[1] as QuerySnapshot;

    debugPrint("📥 Reservations fetched: ${reservationSnapshot.docs.length}");
    debugPrint("🏢 Company data fetched: ${companySnapshot.docs.length}");

    if (companySnapshot.docs.isEmpty) {
      debugPrint("⚠️ No company data found for restaurant: $restaurantId");
      return <int, int>{2: 0, 4: 0, 6: 0, 8: 0, 10: 0};
    }

    final companyData = companySnapshot.docs[0].data() as Map<String, dynamic>;

    // Original total seats from company document
    final seatMap = {
      2: companyData['twoSeat'] ?? 0,
      4: companyData['fourSeat'] ?? 0,
      6: companyData['sixSeat'] ?? 0,
      8: companyData['eightSeat'] ?? 0,
      10: companyData['tenSeat'] ?? 0,
    };

    debugPrint("🏢 Company total seats: $seatMap");

    // Calculate booked tables for the selected date/time
    final DateTime selectedStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    final DateTime selectedEnd = selectedStart.add(Duration(minutes: duration));

    final bookedSeatsMap = <int, int>{2: 0, 4: 0, 6: 0, 8: 0, 10: 0};

    for (final doc in reservationSnapshot.docs) {
       final reservation = ReservationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);

      if (excludeReservationId != null && reservation.id == excludeReservationId) {
        continue; // Skip editing reservation
      }

      final resStart = DateTime(
        reservation.date.year,
        reservation.date.month,
        reservation.date.day,
        reservation.time.toDate().hour,
        reservation.time.toDate().minute,
      );

      final resEnd = resStart.add(Duration(minutes: reservation.duration));

      // Check if reservations overlap with selected slot
      if (selectedStart.isBefore(resEnd) && selectedEnd.isAfter(resStart)) {
        for (final table in reservation.tables) {
          final tableInt = int.tryParse(table);//convert to intiger
          if (tableInt != null) bookedSeatsMap[tableInt] = (bookedSeatsMap[tableInt] ?? 0) + 1;
        }
      }
    }

    debugPrint("🧾 Booked seats map for selected slot: $bookedSeatsMap");

    // Available seats = total seats - booked seats
    final availableSeatsMap = <int, int>{}; //emty map store available table 
    seatMap.forEach((table, total) {
      availableSeatsMap[table] = total - (bookedSeatsMap[table] ?? 0);
    });

    debugPrint("✅ Available seats for selected slot: $availableSeatsMap");

    // Return the map of available seats for all table sizes
    return availableSeatsMap;
  }).handleError((error) {
    debugPrint("❌ Firestore stream error: $error");
    return <int, int>{2: 0, 4: 0, 6: 0, 8: 0, 10: 0};
  });
}


//user present reservation 
Stream<List<Map<String, dynamic>>> userReservationWithCompanyStream() {
  final reservationsRef =
      FirebaseFirestore.instance.collection("reservations");
  final companyRef =
      FirebaseFirestore.instance.collection("companies");

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ User not logged in");
    return const Stream.empty();
  }

  debugPrint("✅ Current User ID: ${user.uid}");

  return reservationsRef
      .where("userId", isEqualTo: user.uid)
      .where("paymentStatus", isEqualTo: "paid")
      .where("status", isEqualTo: "approved")

      // ✅ FILTER STATUS HERE (ended & notReached will NOT come)
      // .where("status", whereNotIn: ["ended", "notReached"])

      .snapshots()
      .asyncMap((reservationSnap) async {

    debugPrint("📦 Reservations fetched: ${reservationSnap.docs.length}");

    if (reservationSnap.docs.isEmpty) {
      debugPrint("⚠️ No reservations found");
      return [];
    }

    List<Map<String, dynamic>> tempResult = [];
    final now = DateTime.now();

    for (final resDoc in reservationSnap.docs) {
      final resData = resDoc.data();

      // ---------------- Validate date & time ----------------
      if (resData["date"] == null || resData["date"] is! Timestamp ||
          resData["time"] == null || resData["time"] is! Timestamp) {
        continue;
      }

      final DateTime reservationDate =
          (resData["date"] as Timestamp).toDate().toLocal();

      final DateTime reservationTime =
          (resData["time"] as Timestamp).toDate().toLocal();

      // ---------------- Calculate start & end datetime ----------------
      final DateTime startDateTime = DateTime(
        reservationDate.year,
        reservationDate.month,
        reservationDate.day,
        reservationTime.hour,
        reservationTime.minute,
      );

      final int durationMinutes = resData["duration"] ?? 60;
      final DateTime endDateTime =
          startDateTime.add(Duration(minutes: durationMinutes));

      // ---------------- Skip expired reservations ----------------
      if (endDateTime.isBefore(now)) {
        continue;
      }

      final String restaurantUserId = resData["restaurantId"];

      // ---------------- Get Company Data ----------------
      final companyQuery = await companyRef
          .where("userId", isEqualTo: restaurantUserId)
          .limit(1)
          .get();

      if (companyQuery.docs.isEmpty) continue;

      final companyData = companyQuery.docs.first.data();

      // ---------------- Add to result ----------------
      tempResult.add({
        "reservationId": resDoc.id,
        "restaurantId": restaurantUserId,
        "restaurantName": companyData["restaurantName"] ?? "",
        "location": companyData["location"] ?? "",
        "image": companyData["logoUrl"] ?? "",
        "date": resData["date"],
        "time": resData["time"],
        "tableno": resData["tableno"],
        "guests": resData["guests"],
        "duration": durationMinutes,
        "depositAmount": resData["depositAmount"],
        "tables": resData["tables"],
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


//user ended reservation streme
Stream<List<Map<String, dynamic>>> userPastReservationsStream() {
  final reservationsRef =
      FirebaseFirestore.instance.collection("reservations");
  final companyRef =
      FirebaseFirestore.instance.collection("companies");

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint("❌ User not logged in");
    return const Stream.empty();
  }

  return reservationsRef
      .where("userId", isEqualTo: user.uid)

      // ✅ Only ended & notReached
      .where("status", whereIn: ["ended", "notReached","cancelledAfterPay"])

      .snapshots()
      .asyncMap((reservationSnap) async {
        if (reservationSnap.docs.isEmpty) return [];

        List<Map<String, dynamic>> tempResult = [];

        for (final resDoc in reservationSnap.docs) {
          final resData = resDoc.data();
          final String restaurantUserId = resData["restaurantId"];

          // ---------------- Get Company Data ----------------
          final companyQuery = await companyRef
              .where("userId", isEqualTo: restaurantUserId)
              .limit(1)
              .get();

          if (companyQuery.docs.isEmpty) continue;

          final companyData = companyQuery.docs.first.data();

          tempResult.add({
            "reservationId": resDoc.id,
            "restaurantId": restaurantUserId,
            "restaurantName": companyData["restaurantName"] ?? "",
            "location": companyData["location"] ?? "",
            "image": companyData["logoUrl"] ?? "",
            "date": resData["date"],
            "time": resData["time"],
            "tableno": resData["tableno"],
            "guests": resData["guests"],
            "duration": resData["duration"],
            "depositAmount": resData["depositAmount"],
            "tables": resData["tables"],
            "foodData": resData["foodData"] ?? [],
            "status": resData["status"],
            "updatedAt": resData["updatedAt"], // Timestamp
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







}





