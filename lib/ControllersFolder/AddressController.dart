import 'package:agitha/ModelsFoder/AddressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

Future<void> addAddress(AddressModel addressModel) async {
  _isLoading = true;
  notifyListeners();

  try {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("User not logged in");
      return;
    }

    final docRef = _firestore.collection('address').doc();

    // ✅ Check if user already has any address
    final existingAddresses = await _firestore
        .collection('address')
        .where('userId', isEqualTo: user.uid)
        .get();

    bool firstAddress = existingAddresses.docs.isEmpty;

    AddressModel newAddress = AddressModel(
      docId: docRef.id,
      userId: user.uid,
      address: addressModel.address,
      housename: addressModel.housename,
      latitude: addressModel.latitude,
      longitude: addressModel.longitude,
      selectedAddress: firstAddress, // ✅ First address auto-selected
    );

    await docRef.set(newAddress.toMap());

    // ✅ If this was the first → no need to update others
    if (!firstAddress) {
      debugPrint("Address added");
    } else {
      debugPrint("First address added and auto-selected ✅");
    }

  } catch (e) {
    debugPrint("Error saving Address: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


Stream<List<AddressModel>> currentUserAddressStream() {
  final user = _auth.currentUser;
  if (user == null) return Stream.value([]);

  return _firestore
      .collection('address')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return AddressModel.fromMap(doc.data(), doc.id);
        }).toList();
      });
}






Future<String> deleteAddress(String docId) async {
  try {
  
    notifyListeners();

    await _firestore.collection('address').doc(docId).delete();

    return "Address deleted successfully ✅";
  } catch (e) {
    debugPrint("Delete Address Error: $e");
    return "Failed to delete address ❌";
  } finally {
 
    notifyListeners();
  }
}

Future<void> setSelectedAddress(String docId) async {
  final user = _auth.currentUser;
  if (user == null) {
    debugPrint("User not logged in");
    return;
  }

  try {
    final snapshot = await _firestore
        .collection('address')
        .where('userId', isEqualTo: user.uid)
        .get();

    // ✅ Unselect all
    for (var doc in snapshot.docs) {
      await doc.reference.update({'selectedAddress': false});
    }

    // ✅ Select the tapped one
    await _firestore.collection('address').doc(docId).update({
      'selectedAddress': true,
    });

    notifyListeners();
    debugPrint("✅ Address selected correctly!");
  } catch (e) {
    debugPrint("❌ Error selecting address: $e");
  }
}

Stream<AddressModel?> selectedAddressStream() {
  final user = _auth.currentUser;
  if (user == null) return Stream.value(null);

  return _firestore
      .collection('address')
      .where('userId', isEqualTo: user.uid) // ✅ Only current user
      .where('selectedAddress', isEqualTo: true) // ✅ Correct field name
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final doc = snapshot.docs.first;
          return AddressModel.fromMap(doc.data(), doc.id);
        }
        return null;
      });
}

// check address exist
Future<bool> userHasAddress() async {
  final user = _auth.currentUser;
  if (user == null) return false;

  final snapshot = await _firestore
      .collection('address')
      .where('userId', isEqualTo: user.uid)
      .get();

  return snapshot.docs.isNotEmpty;
}








}







