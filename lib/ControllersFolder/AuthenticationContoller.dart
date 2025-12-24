import 'package:agitha/ModelsFoder/SignUpmodel.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<String> signUp({
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    try {
    
      UserCredential userCredential = await _authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
      
        _currentUser = SignUpModel(
          uid: user.uid,
          email: email,
          password: password,
          role: role,
        );

      
        await _firestore.collection("Users").doc(user.uid).set(_currentUser!.toMap());

        _setLoading(false);
        notifyListeners();

        return "success"; 
      } else {
        _setLoading(false);
        return "User creation failed";
      }
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message ?? "An unknown error occurred";
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
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
      TextButton(
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

                                      Navigator.push(context, MaterialPageRoute(builder:(context)=> const HomePage()));

     }catch(e){

       ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Logout Failed"),
                                        backgroundColor:colorScheme.primary
                                      ),
                                    );




      
     }


  
  } }