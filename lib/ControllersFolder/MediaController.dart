import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../ModelsFoder/MediaModel.dart';

class MediaProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MediaModel> _mediaList = [];
  List<MediaModel> get mediaList => _mediaList;

  // 🔹 Add New Media
  Future<void> addMedia(MediaModel media) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('media').add(media.toMap());
      await fetchAllMedia(); // refresh list
    } catch (e) {
      debugPrint("Error adding media: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Fetch All Media
  Future<void> fetchAllMedia() async {
    try {
      final snapshot = await _firestore.collection('media').get();
      _mediaList = snapshot.docs
          .map((doc) => MediaModel.fromMap(doc.data(), doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching media: $e");
    }
  }

  // 🔹 Update Existing Media
  Future<void> updateMedia(String docId, MediaModel media) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('media').doc(docId).update(media.toMap());
      await fetchAllMedia();
    } catch (e) {
      debugPrint("Error updating media: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Delete Media
  Future<void> deleteMedia(String docId) async {
    try {
      await _firestore.collection('media').doc(docId).delete();
      _mediaList.removeWhere((m) => m.id == docId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting media: $e");
    }
  }
}
