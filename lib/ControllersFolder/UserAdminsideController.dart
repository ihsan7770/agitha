import 'package:agitha/ModelsFoder/UserRegistratioModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserAdminSideProvider extends ChangeNotifier{

final FirebaseFirestore _firestore = FirebaseFirestore.instance;


// bool _isLoading = false;
// bool get isLoading => _isLoading;


// bool _buttonLoading=false;
// bool get buttonloading=>_buttonLoading;


// to get unblocked users
  Stream<List<UserRegistrationModel>> getProfileStream() {
  return _firestore
      .collection('userprofile')
      .where('isBlocked', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return UserRegistrationModel.fromMap(
            doc.data() as Map<String, dynamic>, 
            doc.id,
          );
        }).toList();
      });
}

//to get blocked users
  Stream<List<UserRegistrationModel>> getBlockedProfileStream() {
  return _firestore
      .collection('userprofile')
      .where('isBlocked', isEqualTo: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return UserRegistrationModel.fromMap(
            doc.data() as Map<String, dynamic>, 
            doc.id,
          );
        }).toList();
      });
}

  // ✅ Block User Method
Future<void> blockUser(String documentId, BuildContext context) async {
  try {
    await _firestore.collection('userprofile').doc(documentId).update({
      'isBlocked': true,
    });

    print('User Blocked Successfully ✅');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User blocked successfully")),
    );
    
  } catch (e) {
    print("Block Error ❌: $e");
  }
}




  // ✅ Unblock User Method
 Future<void> UnblockUser(String documentId, BuildContext context) async {
  try {
    await _firestore.collection('userprofile').doc(documentId).update({
      'isBlocked': false,
    });

    print('User Unblocked Successfully ✅');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User unblocked successfully")),
    );

  } catch (e) {
    print("Unblock Error ❌: $e");
  }
}
}




