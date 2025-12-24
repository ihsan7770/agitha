import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:flutter/material.dart';

class HomeCompanyViewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<CompanyRegistrationModel>> localBrandStream() {
    return _firestore
        .collection('companies')
        .where('brandType', isEqualTo: 'Local brand')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CompanyRegistrationModel.fromMap(doc.data()))
            .toList());
  }



  Stream<List<CompanyRegistrationModel>> InternationalBrandStream() {
    return _firestore
        .collection('companies')
        .where('brandType', isEqualTo: 'International brand')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CompanyRegistrationModel.fromMap(doc.data()))
            .toList());
  }





}
