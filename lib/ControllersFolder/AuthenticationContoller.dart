import 'package:agitha/ModelsFoder/SignUpmodel.dart';
import 'package:agitha/viewfolder/Screens/UserMainPage.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthenticationController extends ChangeNotifier {
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignUpModel? _currentUser;
  bool _isLoading = false;

  SignUpModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

String? _verificationId;

  /// 🔹 SIGNUP → EMAIL + OTP SEND
Future<String> signUp({
  required String email,
  required String password,
  required String phoneNumber,
}) async {
  _setLoading(true);

  try {
    // 1️⃣ SEND OTP first
     await _authentication.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) {
      debugPrint("⚠ Auto-verification ignored for safety");
      },

// more secure code
  //  verificationCompleted: (PhoneAuthCredential credential) async {
  //       debugPrint("⚡ Auto OTP verified");

  //       try {
  //         // 🔗 Try linking phone if possible (optional, safe)
  //         User? user = _authentication.currentUser;
  //         if (user != null) {
  //           await user.linkWithCredential(credential);
  //           debugPrint("✅ Phone auto-linked");
  //         }
  //       } catch (e) {
  //         debugPrint("❌ Auto-link error: $e");
  //       } finally {
  //         _setLoading(false); // 🔵 STOP LOADING
  //       }
  //     },


      verificationFailed: (FirebaseAuthException e) {
        debugPrint("❌ OTP failed: ${e.message}");
        _setLoading(false);
        throw Exception(e.message);
      },

      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        debugPrint("📩 OTP SENT");
        _setLoading(false);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint("⏰ OTP timeout");
        _verificationId = verificationId;
      },
    );

    return "OTP sent, verify first"; // Navigate to OTP screen
  } catch (e) {
    debugPrint("❌ Signup error: $e");
    _setLoading(false);
    return e.toString();
  }
}

//otp resent 
Future<void> resendOTP(String phoneNumber) async {
  await _authentication.verifyPhoneNumber(
    phoneNumber: phoneNumber,

    verificationCompleted: (PhoneAuthCredential credential) async {
      // Auto verification (Android)
      await _authentication.signInWithCredential(credential);
    },

    verificationFailed: (FirebaseAuthException e) {
      print("Verification Failed: ${e.message}");
    },

    codeSent: (String verificationId, int? resendToken) {
      print("OTP Sent Successfully");
      _verificationId = verificationId;
    },

    codeAutoRetrievalTimeout: (String verificationId) {
      _verificationId = verificationId;
    },
  );
}





  // 🔹 LOGIN (role-based)
  Future<String> login({
  required String email,
  required String password,
}) async {
  _setLoading(true);
  try {
    // 🔹 Sign in with Firebase Auth
    UserCredential userCredential = await _authentication.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;
    if (user == null) {
      _setLoading(false);
      return "User not found.";
    }

    // 🔹 Fetch user data from Firestore
    DocumentSnapshot snapshot =
        await _firestore.collection("Users").doc(user.uid).get();

    if (!snapshot.exists) {
      _setLoading(false);
      return "User data not found in database.";
    }

    _currentUser = SignUpModel.fromMap(snapshot.data() as Map<String, dynamic>);
    _setLoading(false);
    notifyListeners();

    // 🔹 Return role for navigation
    return _currentUser!.role;

  } on FirebaseAuthException catch (e) {
    _setLoading(false);

    // 🔹 Handle common Firebase login errors
    switch (e.code) {
      case "user-not-found":
        return "No account found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "invalid-email":
        return "Invalid email format.";
      case "user-disabled":
        return "This account has been disabled.";
      default:
        return "Invalid email or password Please try again.";
    }

  } catch (e) {
    _setLoading(false);
    return "Something went wrong. Please try again.";
  }
}

Future<String> verifyOtpAndSignUpUser({
  required String otp,
  required String email,
  required String password,
  required String phone,
  required String role,
}) async {
  _setLoading(true);

  try {
    if (_verificationId == null) {
      throw Exception("OTP not sent");
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    // 🔐 FIRST create the email user AFTER OTP verification
    UserCredential userCredential =
        await _authentication.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User user = userCredential.user!;
    debugPrint("✅ Email user created after OTP: ${user.uid}");

    // 🔗 Link phone credential
    await user.linkWithCredential(credential);

    // Save to Firestore
    await _firestore.collection("Users").doc(user.uid).set({
      "userId": user.uid,
      "email": email,
      "phone": phone,
      "role": role,
      "createdAt": FieldValue.serverTimestamp(),
    });

    _setLoading(false);
    return "success";
  } catch (e) {
    _setLoading(false);
    return e.toString();
  }
}

   Future<void> _deleteInvalidUser() async {
    final user = _authentication.currentUser;
    if (user != null) {
      await user.delete();
    }
  }


// check loged in user

bool get isLoggedIn => _authentication.currentUser != null;

  // Function to check login and show alert if not logged in
  bool checkLogin(BuildContext context) {
    if (!isLoggedIn) {
      // Show alert if not logged in
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
    title: const Text('Login'),
    content: const Text('Please login to continue'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context), // Cancel
        child: const Text('Cancel'),
      ),

      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder:(context)=> const LoginPage()));
        },
        child: const Text('Login'),
      ),
    ],
  ),
      );
      return false;
    }
    return true; // User is logged in
  }

   //Check the Company Already Registerd

Future<bool> isCompanyRegistered() async {
  try {
    User? user = _authentication.currentUser;
    if (user == null) return false; // Not logged in

    // Query the companies collection where 'userId' matches current UID
    QuerySnapshot query = await _firestore
        .collection('companies')
        .where('userId', isEqualTo: user.uid)
        .limit(1) // Only need to check if at least one exists
        .get();

    return query.docs.isNotEmpty; // True if a document exists
  } catch (e) {
    print("Error checking company registration: $e");
    return false;
  }
}

   //Check the DeliveryBoy Already Registerd

Future<bool> isDeliveryBoyRegistered() async {
  try {
    User? user = _authentication.currentUser;
    if (user == null) return false; // Not logged in

    // Query the companies collection where 'userId' matches current UID
    QuerySnapshot query = await _firestore
        .collection('deliveryBoys')
        .where('db_userId', isEqualTo: user.uid)
        .limit(1) // Only need to check if at least one exists
        .get();

    return query.docs.isNotEmpty; // True if a document exists
  } catch (e) {
    print("Error checking Delivery boy  registration: $e");
    return false;
  }
}





















  // 🔹 LOGOUT
  Future<void> logout(BuildContext context) async {
     final colorScheme = Theme.of(context).colorScheme;

     try{

    await _authentication.signOut();
    _currentUser = null;

    //  ScaffoldMessenger.of(context).showSnackBar(
    //                                   SnackBar(
    //                                     content: const Text("Logged out succesfully"),
    //                                     backgroundColor:colorScheme.primary
    //                                   ),
    //                                 );

                                      Navigator.push(context, MaterialPageRoute(builder:(context)=> const UserMainPage()));

     }catch(e){

       ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Logout Failed"),
                                        backgroundColor:colorScheme.primary
                                      ),
                                    );
   }

     


  
  }
  
  
     //splash logic
Stream<String?> getUserRoleStream() {
    final uid = _authentication.currentUser?.uid;

    if (uid == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('Users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()?['role'] as String?;
      }
      return null;
    });
  }

  
  
  
  
   }