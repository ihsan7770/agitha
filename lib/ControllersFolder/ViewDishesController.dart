import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ViewDishesController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final StreamController<List<Map<String, dynamic>>> _specialStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  final StreamController<List<Map<String, dynamic>>> _normalStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  Stream<List<Map<String, dynamic>>> get specialFoodStream =>
      _specialStreamController.stream;

  Stream<List<Map<String, dynamic>>> get normalFoodStream =>
      _normalStreamController.stream;

 void fetchFoodItemsByIdSpecial(String restaurantId) {
  _firestore
      .collection('foodItems')
      .where('category', isEqualTo: 'Special')
      .where('restaurantId', isEqualTo: restaurantId)
      .snapshots()
      .listen((snapshot) {
    final list = snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;    // ⭐ ADD DOC-ID
      return data;
    }).toList();

    _specialStreamController.add(list);
  });
}

void fetchFoodItemsByIdNormal(String restaurantId) {
  _firestore
      .collection('foodItems')
      .where('category', isEqualTo: 'Normal')
      .where('restaurantId', isEqualTo: restaurantId)
      .snapshots()
      .listen((snapshot) {
    final list = snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;    // ⭐ ADD DOC-ID
      return data;
    }).toList();

    _normalStreamController.add(list);
  });
}
  @override
  void dispose() {
    _specialStreamController.close();
    _normalStreamController.close();
    super.dispose();
  }
}
