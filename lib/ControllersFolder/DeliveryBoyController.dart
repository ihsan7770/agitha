import 'dart:io';

import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DeliveryBoyProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<String>_companies=[];
  List <String> get companies =>_companies;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

   Future<String> registerDeliveryBoy({

  //  required String db_id,
  //  required String db_userId,
   required String db_name,
   required String db_phone,
  
   required String db_restaurantname,
   required String db_gender,
   required String db_vehicle,
   required String db_location, 
   required String working_restaurant_docId, 
   
   required int db_age,
  //  required DateTime createdAt,
    required File db_licenceUrl,




 
   })async{
    try{
       _setLoading(true);
      final user = _auth.currentUser;
      if (user == null) return "User not logged in";

      final deliveryboyId = const Uuid().v4();

      // Upload licence
      final db_licenceRef = _storage
          .ref()
          .child('licence')
          .child('$deliveryboyId-licence.jpg');
      await db_licenceRef.putFile(db_licenceUrl);
      final db_licenceDownloadUrl = await db_licenceRef.getDownloadURL();


          // Create model
      final deliveryboy = DeliveryBoyModel(
        db_id:deliveryboyId,
        db_userId:user.uid,
        db_age: db_age,
        db_gender:db_gender,
        db_licenceUrl:db_licenceDownloadUrl,
        db_name:db_name,
        db_phone: db_phone,
        db_location: db_location,
        working_restaurant_docId: working_restaurant_docId,
        rating: 0,
    
        db_restaurantname:db_restaurantname ,
        db_vehicle:db_vehicle ,
        updatedAt:DateTime.now() ,
    
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore.collection('deliveryBoys').doc(deliveryboyId).set(deliveryboy.toMap());

      _setLoading(false);
      return "DeliveryBoy registered successfully!";







    }catch(e){

        _setLoading(false);
      return "Error: ${e.toString()}";
    }



    }

    //update db
   Future<String> updateDeliveryBoy({
  required String db_id,
  required String db_name,
  required String db_phone,
  required int db_age,
  required String db_restaurantname,
  required String db_gender,
  required String db_vehicle,
  required String db_location,
  required String working_restaurant_docId,
  File? newDbLicenceImage,
}) async {
  try {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> updateData = {
      "db_name": db_name,
      "db_phone": db_phone,
      "db_age": db_age,
      "db_restaurantname": db_restaurantname,
      "db_gender": db_gender,
      "db_vehicle": db_vehicle,
      "db_location": db_location,
      "working_restaurant_docId": working_restaurant_docId,
    };

    // 🔹Upload new image if selected
    if (newDbLicenceImage != null) {
      final db_licenceRef = _storage
          .ref()
          .child('licence')
          .child('$db_id-licence.jpg');

      await db_licenceRef.putFile(newDbLicenceImage);
      final db_licenceDownloadUrl = await db_licenceRef.getDownloadURL();

      updateData['db_licenceUrl'] = db_licenceDownloadUrl;
    }

    await FirebaseFirestore.instance
        .collection("deliveryBoys")
        .doc(db_id)
        .update(updateData);

    _isLoading = false;
    notifyListeners();
    return "Profile Updated Successfully";

  } catch (e) {
    _isLoading = false;
    notifyListeners();
    return "Update failed: $e";
  }
}

    
   



// Fetch the restaurantNames and show dropdown
  
  Stream<List<Map<String, dynamic>>> fetchCompaniesStream() {
    return _firestore.collection('companies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.data()['userId'] ?? '', // Document ID
          'restaurantName': doc.data()['restaurantName'] ?? 'Unnamed',
        };
      }).toList();
    });
  }
}








