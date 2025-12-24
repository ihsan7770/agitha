import 'dart:io';

import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestaurantHomeProvider extends ChangeNotifier{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;  
      final FirebaseStorage _storage = FirebaseStorage.instance;

//fetch restourant data in restourent side with uid

CompanyRegistrationModel? _restaurant;
bool _restaurantLoading = false;


CompanyRegistrationModel? get restaurant => _restaurant;
bool get restaurantLoading => _restaurantLoading;

Stream<CompanyRegistrationModel?> restaurantStream() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    debugPrint("No user logged in");
    return const Stream.empty();
  }

  String currentUid = currentUser.uid;

  // Return a Firestore query stream
  return _firestore
      .collection('companies')
      .where('userId', isEqualTo: currentUid)
      .snapshots()
      .map((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          var doc = querySnapshot.docs.first;
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // include document ID

          debugPrint("✅ Stream update: ${data['restaurantName']}");
          return CompanyRegistrationModel.fromMap(data);
        } else {
          debugPrint("⚠️ No restaurant found for userId: $currentUid");
          return null;
        }
      });
}


//update profile


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  

 Future<String> updateCompany({
    required String companyId,
    required String restaurantName,
    required String brandType,
    required String instagramUrl,
    required String facebookUrl,
    required String twitterUrl,
    required String description,
    required String location,
    required String phone,
    required int twoSeat,
    required int fourSeat,
    required int sixSeat,
    required int eightSeat,
    required int tenSeat,
    required int decorationAmount,
    required int noDecorationAmount,
    required int reservationAmount,
    File? logoImage, // optional
    File? restaurantImage, // optional
  }) async {
    try {
      _setLoading(true);

      final companyDoc = await _firestore.collection('companies').doc(companyId).get();
      if (!companyDoc.exists) {
        _setLoading(false);
        return "Company not found";
      }

      final currentData = companyDoc.data()!;
      String logoUrl = currentData['logoUrl'];
      String restaurantUrl = currentData['restaurantImageUrl'];

      // Upload new logo if selected
      if (logoImage != null) {
        final logoRef =
            _storage.ref().child('company_logos').child('$companyId-logo.jpg');
        await logoRef.putFile(logoImage);
        logoUrl = await logoRef.getDownloadURL();
      }

      // Upload new restaurant image if selected
      if (restaurantImage != null) {
        final restaurantRef = _storage
            .ref()
            .child('restaurant_images')
            .child('$companyId-restaurant.jpg');
        await restaurantRef.putFile(restaurantImage);
        restaurantUrl = await restaurantRef.getDownloadURL();
      }

      // Update Firestore
      await _firestore.collection('companies').doc(companyId).update({
        'restaurantName': restaurantName,
        'brandType': brandType,
        'instagramUrl': instagramUrl,
        'facebookUrl': facebookUrl,
        'twitterUrl': twitterUrl,
        'description': description,
        'location':location,
        'phone':phone,
        'twoSeat': twoSeat,
        'fourSeat': fourSeat,
        'sixSeat': sixSeat,
        'eightSeat': eightSeat,
        'tenSeat': tenSeat,
        'decorationAmount': decorationAmount,
        'noDecorationAmount': noDecorationAmount,
        'reservationAmount': reservationAmount,
        'logoUrl': logoUrl,
        'restaurantImageUrl': restaurantUrl,
        'updatedAt': DateTime.now(),
      });

      _setLoading(false);
      return "Company updated successfully!";
    } catch (e) {
      _setLoading(false);
      return "Error updating company: ${e.toString()}";
    }
  }

}

