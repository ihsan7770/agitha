import 'package:agitha/ModelsFoder/AboutModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AboutProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AboutUsModel? _aboutData;
  AboutUsModel? get aboutData => _aboutData;

  bool _isLoading = false; // For loading the About Us section
  bool _isButtonLoading = false; // For button (submit/update) loading state

  bool get isLoading => _isLoading;
  bool get isButtonLoading => _isButtonLoading;

  /// 🔹 Fetch a specific About document by ID
  Future<void> fetchAbout(String docId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore.collection('about').doc(docId).get();
      if (doc.exists) {
        _aboutData = AboutUsModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint("Error fetching About data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 Update or create About document
  Future<void> updateAbout(String docId, AboutUsModel about) async {
    _isButtonLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('about').doc(docId).set(about.toMap());
      _aboutData = about;
    } catch (e) {
      debugPrint("Error updating About data: $e");
    }

    _isButtonLoading = false;
    notifyListeners();
  }

  /// 🔹 Fetch the first About document (if you have only one)
  Future<void> fetchAboutData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore.collection('about').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        _aboutData = AboutUsModel.fromMap(doc.data(), doc.id);
      }
    } catch (e) {
      debugPrint("Error fetching About Us data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
