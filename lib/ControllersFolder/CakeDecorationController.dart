import 'package:agitha/ModelsFoder/CakeDecorationModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ModelsFoder/DecorationModel.dart';

class CakeDecorationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CakeDecorationModel> _decorations = [];
  List<CakeDecorationModel> get decorations => _decorations;

    bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String collectionName = "cakeDecorations";

  /// ------------------ FETCH ------------------
  Future<void> fetchDecorations() async {
    final restaurantId= FirebaseAuth.instance.currentUser!.uid;
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where("restauratId", isEqualTo: restaurantId)
          .get();

      _decorations = snapshot.docs
          .map((doc) => CakeDecorationModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Cake Decoration Error: $e");
    }
  }

  /// ------------------ ADD ------------------
Future<void> addDecoration(CakeDecorationModel model) async {
  try {
    _isLoading = true;
    notifyListeners();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = _firestore.collection(collectionName).doc();

    final newModel = CakeDecorationModel(
      docId: docRef.id,
      restauratId: userId, // ✅ current user id
      decorationPrice: model.decorationPrice,
      decorationDetails: model.decorationDetails,
    );

    await docRef.set(newModel.toMap());

    _decorations.add(newModel);
  } catch (e) {
    debugPrint("Add Cake Decoration Error: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// ------------------ UPDATE ------------------
  Future<void> updateDecoration(CakeDecorationModel model) async {
  try {
    _isLoading = true;
    notifyListeners();

    await _firestore
        .collection(collectionName)
        .doc(model.docId)
        .update(model.toMap());

    final index =
        _decorations.indexWhere((e) => e.docId == model.docId);
    if (index != -1) _decorations[index] = model;

  } catch (e) {
    debugPrint("Update Cake Decoration Error: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// ------------------ DELETE ------------------
  Future<void> deleteDecoration(String docId) async {
    try {
      await _firestore.collection(collectionName).doc(docId).delete();

      _decorations.removeWhere((element) => element.docId == docId);
      notifyListeners();
    } catch (e) {
      debugPrint("Delete Decoration Error: $e");
    }
  }
}
