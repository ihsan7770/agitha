

import 'package:agitha/ModelsFoder/AddJobVacancyModel.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/AddJobVaccancy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddJobVaccancyProvider extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  Future<String> addjobvaccacy({
  required String jobTitle,
  required String jobCode,
  required String jobType,
  required String department,
  required String jobResponsibility,
  required String jobDescription,
  required String jobRequirements,
  required String jobLocation,
  required String salaryRange,
}) async {
  try {
    _setLoading(true);

    // Generate unique document ID
    final String documentId = FirebaseFirestore.instance.collection('job_vacancies').doc().id;

    // Create model object
    final addJob = AddJobVaccancys(
      documentId: documentId,
      jobTitle: jobTitle,
      jobCode: jobCode,
      jobType: jobType,
      department: department,
      jobResponsibility: jobResponsibility,
      jobDescription: jobDescription,
      jobRequirements: jobRequirements,
      jobLocation: jobLocation,
      salaryRange: salaryRange,
      // applicationDeadline: 
    );

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('job_vacancies')
        .doc(documentId)
        .set(addJob.toMap());

    debugPrint("✅ Job vacancy added successfully: $documentId");
    return documentId;
  } catch (e) {
    debugPrint("❌ Error adding job vacancy: $e");
    rethrow;
  } finally {
    _setLoading(false);
  }
}

 /// ✅ Stream all job vacancies (auto-updates on change)
  Stream<List<AddJobVaccancys>> getJobVacanciesStream() {
    return _firestore.collection('job_vacancies').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              AddJobVaccancys.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
/// ✅ Fetch single job vacancy by document ID
Future<AddJobVaccancys?> getJobById(String documentId) async {
  try {
    final doc =
        await _firestore.collection('job_vacancies').doc(documentId).get();

    if (doc.exists) {
      return AddJobVaccancys.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching job by ID: $e");
    return null;
  }
}


  /// ✅ Update job vacancy
  Future<void> updateJobVacancy({
    required String documentId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      _setLoading(true);
      await _firestore
          .collection('job_vacancies')
          .doc(documentId)
          .update(updatedData);
      debugPrint("✅ Job updated successfully: $documentId");
    } catch (e) {
      debugPrint("❌ Error updating job: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  /// ✅ Delete job vacancy
  Future<void> deleteJobVacancy(String documentId) async {
    try {
      _setLoading(true);
      await _firestore.collection('job_vacancies').doc(documentId).delete();
      debugPrint("🗑️ Job deleted successfully: $documentId");
    } catch (e) {
      debugPrint("❌ Error deleting job: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }






}