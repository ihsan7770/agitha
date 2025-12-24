import 'dart:io';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class CompanyRegistrationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  

//   /// Upload company registration data to Firebase
Future<String> registerCompany({
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
  required File logoImage,
  required File restaurantImage,
}) async {
    try {
      _setLoading(true);
      final user = _auth.currentUser;
      if (user == null) return "User not logged in";

      final companyId = const Uuid().v4();

      // Upload logo
      final logoRef = _storage
          .ref()
          .child('company_logos')
          .child('$companyId-logo.jpg');
      await logoRef.putFile(logoImage);
      final logoUrl = await logoRef.getDownloadURL();

      // Upload restaurant image
      final restaurantRef = _storage
          .ref()
          .child('restaurant_images')
          .child('$companyId-restaurant.jpg');
      await restaurantRef.putFile(restaurantImage);
      final restaurantUrl = await restaurantRef.getDownloadURL();

final company = CompanyRegistrationModel(
  id: companyId,
  userId: user.uid,
  restaurantName: restaurantName,
  brandType: brandType,
  instagramUrl: instagramUrl,
  facebookUrl: facebookUrl,
  twitterUrl: twitterUrl,
  description: description,
  logoUrl: logoUrl,
  rating: 0,
  restaurantImageUrl: restaurantUrl,
  location: location,
  phone: phone,
  twoSeat: twoSeat,
  fourSeat: fourSeat,
  sixSeat: sixSeat,
  eightSeat: eightSeat,
  tenSeat: tenSeat,
  decorationAmount: decorationAmount, // Add this
  noDecorationAmount: noDecorationAmount, // Add this
  reservationAmount: reservationAmount, // Add this
  createdAt: DateTime.now(),
);


      // Save to Firestore
      await _firestore.collection('companies').doc(companyId).set(company.toMap());

      _setLoading(false);
      return "Company registered successfully!";
    }
    
    
     catch (e) {
      _setLoading(false);
      return "Error: ${e.toString()}";
    }
  }







}
