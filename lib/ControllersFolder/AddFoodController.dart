import 'dart:io';

import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Addfoodprovider extends ChangeNotifier{

 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
 final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// ✅ Add a new food item with image upload + auto fetch restaurant details
  Future<void> addFoodItem({
    required String dishName,
    required String describtion,
    required String price,
    required String category,
    required File imageFile,
  }) async {
    try {
        _isLoading = true;
         notifyListeners();
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        throw Exception("No logged-in restaurant user found");
      }

      // 🔹 Step 1: Fetch restaurant details from 'companies' collection
      QuerySnapshot companyQuery = await _firestore
          .collection('companies')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (companyQuery.docs.isEmpty) {
        throw Exception("No restaurant found for the current user");
      }

      var companyData =
          companyQuery.docs.first.data() as Map<String, dynamic>;

      String restaurantId = currentUser.uid; // ✅ Use logged-in user's UID
// Firestore doc ID
      String restaurantName =
          companyData['restaurantName'] ?? 'Unknown Restaurant';

      // 🔹 Step 2: Upload image to Firebase Storage
      String fileName =
          'food_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage.ref(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // 🔹 Step 3: Create food model
      FoodItemModel newFood = FoodItemModel(
        id: '', // Firestore will auto-generate this
        dishName: dishName,
        describtion: describtion,
        price: price,
        rating: 0,
        category: category,
        imageUrl: downloadUrl,
        restaurantId: restaurantId,
        restaurantName: restaurantName,
        createdAt: DateTime.now(),
      );

      // 🔹 Step 4: Save to Firestore
      await _firestore.collection('foodItems').add(newFood.toMap());
         print('✅ Food item added successfully for $restaurantName!');
  } catch (e) {
    print('❌ Error adding food item: $e');
    rethrow;
  } finally {
    _isLoading = false; // ✅ Always stop loading
    notifyListeners(); // ✅ Refresh UI
  }
  }



  //show normal dishes
   Stream<List<FoodItemModel>> streamNormalFoodItems() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      // Return empty stream if no user is logged in
      return const Stream.empty();
    }

    return _firestore
        .collection('foodItems')
        .where('category', isEqualTo: 'Normal')
        .where('restaurantId', isEqualTo: currentUser.uid) // ✅ filter by current restaurant
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodItemModel.fromDoc(doc);
      }).toList();
    });
  }

 //show special dishes
    Stream<List<FoodItemModel>> streamSpecialFoodItems() {
        final currentUser = _auth.currentUser;
    if (currentUser == null) {
      // Return empty stream if no user is logged in
      return const Stream.empty();
    }
    return _firestore
        .collection('foodItems')
        .where('category', isEqualTo: 'Special')
         .where('restaurantId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FoodItemModel.fromDoc(doc);
      }).toList();
    });
  }
  //update food item
  
Future<void> updateFoodItem({
  required String foodItemId,
   // ✅ pass the specific food document ID here
  required String dishName,
  required String describtion,
  required String price,
  required String category,
  File? newImageFile, // nullable (only if user uploads a new one)
}) async {
  try {
    _isLoading = true;
    notifyListeners();

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No logged-in restaurant user found");
    }

    // 🔹 Step 1: Fetch restaurant details
    QuerySnapshot companyQuery = await _firestore
        .collection('companies')
        .where('userId', isEqualTo: currentUser.uid)
        .limit(1)
        .get();

    if (companyQuery.docs.isEmpty) {
      throw Exception("No restaurant found for current user");
    }

    var companyData =
        companyQuery.docs.first.data() as Map<String, dynamic>;
    String restaurantName =
        companyData['restaurantName'] ?? 'Unknown Restaurant';

    // 🔹 Step 2: Prepare image URL
    String? imageUrl;
    if (newImageFile != null) {
      String fileName =
          'food_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage.ref(fileName).putFile(newImageFile);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    // 🔹 Step 3: Prepare update data
    Map<String, dynamic> updatedData = {
      'dishName': dishName,
      'price': price,
      'category': category,
      'restaurantId': currentUser.uid,
      'restaurantName': restaurantName,
      'updatedAt': DateTime.now(),
    };

    if (imageUrl != null) {
      updatedData['imageUrl'] = imageUrl;
    }

    // 🔹 Step 4: Update the specific food item document
    await _firestore.collection('foodItems').doc(foodItemId).update(updatedData);

    _isLoading = false;
    notifyListeners();

    print("✅ Food item updated successfully!");
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    print("❌ Error updating food item: $e");
    rethrow;
  }
}

//delete food item
Future<void> deleteFoodItem(String foodItemId, BuildContext context) async {
  try {
    _isLoading = true;
    notifyListeners();

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No logged-in restaurant user found");
    }

    DocumentSnapshot foodDoc = 
        await _firestore.collection('foodItems').doc(foodItemId).get();

    if (!foodDoc.exists) {
      throw Exception("Food item not found");
    }

    var foodData = foodDoc.data() as Map<String, dynamic>;
    if (foodData['restaurantId'] != currentUser.uid) {
      throw Exception("You are not authorized to delete this food item");
    }

    await _firestore.collection('foodItems').doc(foodItemId).delete();

    _isLoading = false;
    notifyListeners();

    // Show SnackBar here with the provided context
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Food item deleted successfully"),
        
        ),
      );
    }
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete: $e"),
         
        ),
      );
    }
    rethrow;
  }
}






} 