import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestaurantViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;  
   final FirebaseAuth _authentication = FirebaseAuth.instance;

  String? _userId;
  String? get userId => _userId;

 RestaurantViewProvider() {
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


// fech in admin side

  CompanyRegistrationModel? _company;
  bool _loading = false;

  CompanyRegistrationModel? get company => _company;
  bool get loading => _loading;

 /// Fetch Full company details by userId field
Future<void> fetchCompanyDetails(String companyId) async {
  _loading = true;
  notifyListeners();

  try {
    // Option 2: Query by userId field
    QuerySnapshot query = await _firestore
        .collection('companies')
        .where('userId', isEqualTo: companyId)
        .get();
    
    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;
      var data = doc.data() as Map<String, dynamic>;
      // Add the document ID to the data
      data['id'] = doc.id;
      _company = CompanyRegistrationModel.fromMap(data);
      debugPrint("Successfully fetched company: ${_company?.restaurantName}");
      debugPrint("Document ID: ${doc.id}");
    } else {
      debugPrint("No company found with userId: $companyId");
      _company = null;
    }
  } catch (e) {
    debugPrint("Error fetching company: $e");
    _company = null;
  }

  _loading = false;
  notifyListeners();
}


  // List<Map<String, dynamic>> _companies = [];
  // List<Map<String, dynamic>> get companies => _companies;

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;


  // // admin side view fetching name and email
  // Future<void> fetchCompaniesWithEmails() async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     QuerySnapshot companySnapshot =
  //         await _firestore.collection('companies').get();

  //     List<Map<String, dynamic>> tempList = [];

  //     for (var doc in companySnapshot.docs) {
  //       var companyData = doc.data() as Map<String, dynamic>;
  //       debugPrint("Company Data: $companyData"); // 👀 see what's fetched

  //       String? userId = companyData['userId']?.toString();
  //       String email = '';
        
  //       // Safe handling for restaurant name
  //       String restaurantName = companyData['restaurantName']?.toString() ?? 
                             
  //                              'Unknown Restaurant';

  //       if (userId != null && userId.isNotEmpty) {
  //         DocumentSnapshot userDoc =
  //             await _firestore.collection('Users').doc(userId).get();

  //         if (userDoc.exists) {
  //           var userData = userDoc.data() as Map<String, dynamic>;
  //           email = userData['email']?.toString() ?? 'No email';
  //         } else {
  //           email = 'User not found';
  //         }
  //       } else {
  //         email = 'No user ID';
  //       }

  //       tempList.add({
  //         'userId': userId, // ✅ This is crucial for navigation
  //         'restaurantName': restaurantName,
  //         'email': email,
  //         'docId': doc.id, // Also store the document ID
  //       });
  //     }

  //     _companies = tempList;
  //   } catch (e) {
  //     debugPrint("Error fetching companies with user emails: $e");
  //     _companies = []; // Ensure empty list on error
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }



  //aproval and decline restourant request by admin side

 Future<void> approveRestaurant(String companyId) async {
  notifyListeners();

  await _firestore.collection('companies').doc(companyId).update({
    'status': 'approved', // <-- changed from isApproved to status
  });


}



//decline company
Future<void> declineRestaurant(String companyId) async {
  await _firestore.collection('companies').doc(companyId).update({
    'status': 'rejected', // <-- changed from isApproved to status
  });

}

CompanyRegistrationModel? _restaurant;
bool _restaurantLoading = false;


CompanyRegistrationModel? get restaurant => _restaurant;
bool get restaurantLoading => _restaurantLoading;
  
Future<bool> isRestaurantApproved() async {
  try {
    User? user = _authentication.currentUser;
    if (user == null) return false; // Not logged in

    // Query the companies collection where 'userId' matches current UID
    QuerySnapshot query = await _firestore
        .collection('companies')
        .where('userId', isEqualTo: user.uid)
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



//for button approval change state
Stream<bool> checkRestaurantApprovedStream(String companyId) {
  return _firestore
      .collection('companies')
      .doc(companyId)
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





//stream fro approvel
Stream<QuerySnapshot<Map<String, dynamic>>>? getRestaurantStream(String userId) {
    return _firestore
        .collection('companies')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }



// to check button status in admin side rejection approval

//   // Map to store per-company document streams
// final Map<String, Stream<DocumentSnapshot>> _companyStreams = {};

// /// Get a real-time stream for a specific company by its document ID
// Stream<DocumentSnapshot> companyStream(String docId) {
//   if (!_companyStreams.containsKey(docId)) {
//     _companyStreams[docId] =
//         _firestore.collection('companies').doc(docId).snapshots();
//   }
//   return _companyStreams[docId]!;
// }






// pending and approved strem
Stream<List<Map<String, dynamic>>> streamPendingAndApprovedCompanies() {
  return _firestore
      .collection('companies')
      .where('status', whereIn: ['pending', 'approved'])
      .snapshots()
      .asyncMap((snapshot) async {
        List<Map<String, dynamic>> tempList = [];

        for (var doc in snapshot.docs) {
          var companyData = doc.data() as Map<String, dynamic>;
          String? userId = companyData['userId'];
          String email = 'No Email';

          if (userId != null && userId.isNotEmpty) {
            DocumentSnapshot userDoc =
                await _firestore.collection('Users').doc(userId).get();

            if (userDoc.exists) {
              var userData = userDoc.data() as Map<String, dynamic>;
              email = userData['email'] ?? 'No Email';
            }
          }

          tempList.add({
            'docId': doc.id,
            'restaurantName': companyData['restaurantName'] ?? 'Unknown',
            'email': email,
            'status': companyData['status'] ?? 'Unknown',
            'userId': userId,
          });
        }

        return tempList;
      });
}



//rejected compane streme
Stream<List<Map<String, dynamic>>> getRejectedRestaurantsStream() {
  return _firestore
      .collection('companies')
       .where('status', isEqualTo: 'rejected')
      .snapshots()
      .asyncMap((snapshot) async {
        List<Map<String, dynamic>> tempList = [];

        for (var doc in snapshot.docs) {
          var companyData = doc.data() as Map<String, dynamic>;
          String? userId = companyData['userId'];
          String email = 'No Email';

          if (userId != null && userId.isNotEmpty) {
            DocumentSnapshot userDoc =
                await _firestore.collection('Users').doc(userId).get();

            if (userDoc.exists) {
              var userData = userDoc.data() as Map<String, dynamic>;
              email = userData['email'] ?? 'No Email';
            }
          }

          tempList.add({
            'docId': doc.id,
            'restaurantName': companyData['restaurantName'] ?? 'Unknown',
            'email': email,
            'status': companyData['status'] ?? 'Unknown',
            'userId': userId,
          });
        }

        return tempList;
      });
}









  
}





