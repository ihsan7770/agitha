import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../ModelsFoder/DecorationModel.dart';

class DecorationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DecorationModel> _decorations = [];
  List<DecorationModel> get decorations => _decorations;

    bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String collectionName = "decorations";

  /// ------------------ FETCH ------------------
  Future<void> fetchDecorations() async {
    final restaurantId= FirebaseAuth.instance.currentUser!.uid;
    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where("restauratId", isEqualTo: restaurantId)
          .get();

      _decorations = snapshot.docs
          .map((doc) => DecorationModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Fetch Decoration Error: $e");
    }
  }

  /// ------------------ ADD ------------------
Future<void> addDecoration(DecorationModel model) async {
  try {
    _isLoading = true;
    notifyListeners();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final docRef = _firestore.collection(collectionName).doc();

    final newModel = DecorationModel(
      docId: docRef.id,
      restauratId: userId, // ✅ current user id
      eventName: model.eventName,
      decorationDetails: model.decorationDetails,
    );

    await docRef.set(newModel.toMap());

    _decorations.add(newModel);
  } catch (e) {
    debugPrint("Add Decoration Error: $e");
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  /// ------------------ UPDATE ------------------
  Future<void> updateDecoration(DecorationModel model) async {
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
    debugPrint("Update Decoration Error: $e");
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
