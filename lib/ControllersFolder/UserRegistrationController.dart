import 'dart:async';
import 'dart:io';

import 'package:agitha/ModelsFoder/UserRegistratioModel.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserRegistrationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

  StreamSubscription<User?>? _authSubscription;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

 

  StreamSubscription<DocumentSnapshot>? _userDocSubscription;

  String? email;
  String? name;
  String? role;

  UserRegistrationProvider() {
    debugPrint("🟢 Provider initialized");
    _listenToAuth();
  }

  void _listenToAuth() {
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      debugPrint("🔄 Auth changed");

      if (user != null) {
        debugPrint("✅ Logged in UID: ${user.uid}");

        email = user.email;
        name = _extractNameFromEmail(email ?? '');

        /// 🔥 Listen to Firestore document stream
        _userDocSubscription = _firestore
            .collection('Users')
            .doc(user.uid)
            .snapshots()
            .listen((doc) {

          if (doc.exists) {
            final data = doc.data();
            role = data?['role'];

            debugPrint("📄 Firestore role: $role");
          } else {
            debugPrint("❌ No user document found");
            role = null;
          }

          _isLoading = false;
          notifyListeners();
        });

      } else {
        debugPrint("🚪 Logged out");

        email = null;
        name = null;
        role = null;

        _userDocSubscription?.cancel();
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  String _extractNameFromEmail(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return "User";
  }

  @override
  void dispose() {
    debugPrint("🛑 Disposing Provider");
    _authSubscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }

  // String _extractNameFromEmail(String email) {
  //   final localPart = email.split('@')[0];
  //   final cleaned = localPart.replaceAll(RegExp(r'[._\d]+'), ' ').trim();
  //   return cleaned
  //       .split(' ')
  //       .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
  //       .join(' ');
  // }

  //Resgister User



Future<String> registerUser({
  required String username,
  required String phonenumber,
  required String dob,
  required String gender,
  File? profileImageUrl,
}) async {
  try {
    _isLoading = true;
    notifyListeners(); // Start loading

    final user = _auth.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return "User not logged in";
    }

    String? downloadUrl;
    if (profileImageUrl != null) {
      final ref = _storage
          .ref()
          .child("user_profiles")
          .child("${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg");
      await ref.putFile(profileImageUrl);
      downloadUrl = await ref.getDownloadURL();
    }

    final docRef = const Uuid().v4();
    final model = UserRegistrationModel(
      documentid: docRef,
      loggeduserId: user.uid,
      email: user.email ?? 'nomail',
      username: username,
      phonenumber: phonenumber,
      dob: dob,
      gender: gender,
      profileImageUrl: downloadUrl,
    );

    await _firestore.collection('userprofile').doc(docRef).set(model.toMap());

    _isLoading = false; // ✅ Stop loading after completion
    notifyListeners();

    return "Profile saved successfully";
  } catch (e) {
    _isLoading = false; // ✅ Stop loading even on error
    notifyListeners();
    return "Error: $e";
  }
}

// check profile created

Future<bool>checkUserProfileExists() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('userprofile')
        .where('loggeduserId', isEqualTo: user.uid)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking profile: $e');
    return false;
  }
}



  // Future<bool> checkUserProfile(BuildContext context) async {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('User not logged in')),
  //       );
  //       return false;
  //     }

  //     final docSnapshot =
  //         await _firestore.collection('userprofile').doc(user.uid).get();

  //     return docSnapshot.exists;
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error checking profile: $e')),
  //     );
  //     return false;
  //   }
  // }










//here an issue if else printing

//unblock user




//check block state user side
Stream<bool> blockedStatusStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(false);

  return _firestore
      .collection("userprofile")
      .where('loggeduserId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.data()["isBlocked"] ?? false;
        }
        return false;
      });
}


// // ✅ Check user block status by document ID
// Stream<bool> buttonblockedStatusStream(String documentId) {
//   return _firestore
//       .collection("userprofile")
//       .doc(documentId)
//       .snapshots()
//       .map((snapshot) {
//         if (snapshot.exists) {
//           return snapshot.data()?["isBlocked"] ?? false;
//         }
//         return false;
//       });
// }

// // ✅ Check user unblock status by document ID
// Stream<bool> buttonunblockedStatusStream(String documentId) {
//   return _firestore
//       .collection("userprofile")
//       .doc(documentId)
//       .snapshots()
//       .map((snapshot) {
//         if (snapshot.exists) {
//           return snapshot.data()?["isBlocked"] ?? true;
//         }
//         return true;
//       });
// }


//user profile details
Stream<Map<String, dynamic>?> currentUserProfileStream() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return _firestore
      .collection("userprofile")
      .where('loggeduserId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.data(); // Return full user details
        }
        return null;
      });
}

Future<String> updateUser({
  required String username,
  required String phonenumber,
  required String dob,
  required String gender,
  File? profileImageFile,
  required String? oldImageUrl,
  required String docId,
}) async {
  try {
    _isLoading = true;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return "User not logged in";
    }

    String updatedImageUrl = oldImageUrl ?? "";

    // ✅ Upload new image only if picked
    if (profileImageFile != null) {
      // Delete old image if exists
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(oldImageUrl).delete();
        } catch (_) {}
      }

      final ref = _storage
          .ref()
          .child('user_profiles')
          .child("${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg");

      await ref.putFile(profileImageFile);
      updatedImageUrl = await ref.getDownloadURL();
    }

    // ✅ Update Firestore
    await _firestore.collection("userprofile").doc(docId).update({
      "username": username,
      "phonenumber": phonenumber,
      "dob": dob,
      "gender": gender,
      "profileImageUrl": updatedImageUrl, // ✅ Fixed field name
    });

    return "Profile updated successfully ✅";
  } catch (e) {
    debugPrint("Update User Error: $e");
    return "Failed to update profile ❌";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}










}








