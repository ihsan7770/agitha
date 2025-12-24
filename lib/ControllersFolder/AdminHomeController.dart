import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardStreamProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Counts
  int _deliveryBoyCount = 0;
  int _companyCount = 0;
  int _userProfileCount = 0;

  int get deliveryBoyCount => _deliveryBoyCount;
  int get companyCount => _companyCount;
  int get userProfileCount => _userProfileCount;

  // StreamSubscriptions
  StreamSubscription? _deliveryBoySub;
  StreamSubscription? _companySub;
  StreamSubscription? _userProfileSub;

  // Constructor
  DashboardStreamProvider() {
    _listenToFirestore();
  }

  void _listenToFirestore() {
    // 👇 Listen to deliveryBoys collection
    _deliveryBoySub =
        _firestore.collection('deliveryBoys').snapshots().listen((snapshot) {
      _deliveryBoyCount = snapshot.docs.length;
      notifyListeners();
    });

    // 👇 Listen to companies collection
    _companySub =
        _firestore.collection('companies').snapshots().listen((snapshot) {
      _companyCount = snapshot.docs.length;
      notifyListeners();
    });

    // 👇 Listen to userprofile collection
    _userProfileSub =
        _firestore.collection('userprofile').snapshots().listen((snapshot) {
      _userProfileCount = snapshot.docs.length;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _deliveryBoySub?.cancel();
    _companySub?.cancel();
    _userProfileSub?.cancel();
    super.dispose();
  }
}
