

import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveryBoyViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _authentication = FirebaseAuth.instance;


//to fech user id
  String? _userId;

  String? get userId => _userId;

 DeliveryBoyViewProvider() {
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
//used to map list of strings
  List<Map<String, dynamic>> _deliveryboy = [];
  List<Map<String, dynamic>> get deliveryboy => _deliveryboy;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
//map model
  DeliveryBoyModel ?_deliveryboys;
  bool _loading = false;
//get the model
  DeliveryBoyModel? get deliveryboys => _deliveryboys;
  bool get loading => _loading;

 /// Fetch Full DeliveryBoy details by userId field
Future<void> fetchDeliveryBoyDetails(String deliveryboyId) async {
  _loading = true;
  notifyListeners();

  try {
    // Option 2: Query by userId field
    QuerySnapshot query = await _firestore
        .collection('deliveryBoys')
        .where('db_userId', isEqualTo: deliveryboyId)
        .get();
    
    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      // Add the document ID to the data
      data['id'] = doc.id;
     _deliveryboys= DeliveryBoyModel.fromMap(data);
      debugPrint("Successfully fetched deliveryboy: ${_deliveryboys?.db_name}");
      debugPrint("Document ID: ${doc.id}");
    } else {
      debugPrint("No  deliveryboy found with userId: $deliveryboyId");
      _deliveryboys = null;
    }
  } catch (e) {
    debugPrint("Error fetching  deliveryboy: $e");
   _deliveryboys = null;
  }

  _loading = false;
  notifyListeners();
}

  // admin side view fetching name and email

  Future<void> fetchDeliveryBoyWithEmails() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot deliveryboy =
          await _firestore.collection('deliveryBoys').get();

      List<Map<String, dynamic>> tempList = [];

      for (var doc in deliveryboy.docs) {
        var deliveryboydata = doc.data() as Map<String, dynamic>;
        // debugPrint("Delivery boy Data: $deliveryboydata"); // 👀 see what's fetched

        String? userId = deliveryboydata['db_userId']?.toString();
        String email = '';
        
        // Safe handling for restaurant name
        String deliveryboyname = deliveryboydata['db_name']?.toString() ?? 
        'Unknown Delivery Boy';
          String deliveryboyLocation =deliveryboydata['db_location']?.toString() ?? 'Unknown Location' ;

        if (userId != null && userId.isNotEmpty) {
          DocumentSnapshot userDoc =
              await _firestore.collection('Users').doc(userId).get();

          if (userDoc.exists) {
            var userData = userDoc.data() as Map<String, dynamic>;
            email = userData['email']?.toString() ?? 'No email';
          } else {
            email = 'User not found';
          }
        } else {
          email = 'No user ID';
        }

        tempList.add({
          'userId': userId, // ✅ This is crucial for navigation
          'db_name': deliveryboyname,
          'db_location':deliveryboyLocation,
          'email': email,
          'docId': doc.id, // Also store the document ID
        });
      }

       _deliveryboy = tempList;
    } catch (e) {
      debugPrint("Error fetching companies with user emails: $e");
       _deliveryboy = []; // Ensure empty list on error
    }

    _isLoading = false;
    notifyListeners();
  }

  


  //aproval and decline DeliveryBoy request by admin side

 Future<void> approveDeliveryBoy(String deliveryBoyId) async {
  notifyListeners();

  await _firestore.collection('deliveryBoys').doc(deliveryBoyId).update({
    'status': 'approved', // <-- changed from isApproved to status
  });

  fetchDeliveryBoyWithEmails(); // refresh list
}




Future<void> declineDeliveryBoy(String deliveryBoyId) async {
  await _firestore.collection('deliveryBoys').doc(deliveryBoyId).update({
    'status': 'rejected', // <-- changed from isApproved to status
  });
  fetchDeliveryBoyWithEmails(); // refresh list
}


  
Future<bool> isDeliveryBoyApproved() async {
  try {
    User? user = _authentication.currentUser;
    if (user == null) return false; // Not logged in

    // Query the companies collection where 'userId' matches current UID
    QuerySnapshot query = await _firestore
        .collection('deliveryBoys')
        .where('db_userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'approved') // <-- check status
        .limit(1)
        .get();

    // If at least one document exists, the restaurant is approved
    return query.docs.isNotEmpty;
  } catch (e) {
    print('Error checking approval: $e');
    return false;
  }
}






Future<bool> checkDeliveryBoyApproved(String deliveryBoyId) async {
  try {
    final docSnapshot =
        await _firestore.collection('deliveryBoys').doc(deliveryBoyId).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null && data.containsKey('status')) {
        return data['status'] == 'approved'; // <-- check status instead
      }
    }
  } catch (e) {
    print('Error checking approval: $e');
  }
  return false;
}




//for button approval change state
Stream<bool> checkDeliveryBoyApprovedStream(String dbId) {
  return _firestore
      .collection('deliveryBoys')
      .doc(dbId)
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








///stream to get real time update
Stream<QuerySnapshot<Map<String, dynamic>>>? getdeliveryBoyStream(String userId) {
    return _firestore
        .collection('deliveryBoys')
        .where('db_userId', isEqualTo: userId)
        .snapshots();
  }




Stream<List<Map<String, dynamic>>> streamPendingAndApprovedDeliveryBoys() {
  return _firestore
      .collection('deliveryBoys')
      .where('status', whereIn: ['pending', 'approved'])
      .snapshots()
      .asyncMap((QuerySnapshot snapshot) async {
    List<Map<String, dynamic>> tempList = [];

    for (var doc in snapshot.docs) {
      var deliveryBoyData = doc.data() as Map<String, dynamic>;

      String? userId = deliveryBoyData['db_userId']?.toString();
      String email = 'No email';
      
      if (userId != null && userId.isNotEmpty) {
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(userId).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          email = userData['email']?.toString() ?? 'No email';
        } else {
          email = 'User not found';
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



Stream<List<Map<String, dynamic>>> streamRejectedDeliveryBoys() {
  return _firestore
      .collection('deliveryBoys')
      .where('status', isEqualTo: 'rejected')
      .snapshots()
      .asyncMap((QuerySnapshot snapshot) async {
    List<Map<String, dynamic>> tempList = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      String? userId = data['db_userId']?.toString();
      String email = 'No email';

      if (userId != null && userId.isNotEmpty) {
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(userId).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          email = userData['email']?.toString() ?? 'No email';
        }
      }

      tempList.add({
        'docId': doc.id,
        'userId': userId,
        'db_name': data['db_name'] ?? 'Unknown',
        'db_location': data['db_location'] ?? 'Unknown',
        'email': email,
        'status': data['status'],
      });
    }

    return tempList;
  });
}






}