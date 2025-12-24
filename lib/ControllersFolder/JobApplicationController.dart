import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../ModelsFoder/JobApplicationModel.dart';

class JobApplicationController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<JobApplicationModel> _userApplications = [];
  List<JobApplicationModel> get userApplications => _userApplications;

Future<void> uploadAndSubmitApplication({
  required File resumeFile,
  required String fullName,
  required String phone,
  required String email,
  required String address,
  required String appliedJob,
}) async {
  try {
    _isLoading = true;
    notifyListeners();

    final String userId = _auth.currentUser!.uid;
    final String fileId = const Uuid().v4();

    // ✅ 1️⃣ Upload Resume
    final Reference ref =
        _storage.ref().child('resumes/${userId}_$fileId.pdf');

    final UploadTask uploadTask = ref.putFile(resumeFile);
    final TaskSnapshot snapshot = await uploadTask;
    final String resumeDownloadUrl = await snapshot.ref.getDownloadURL();

    debugPrint('✅ Resume uploaded successfully: $resumeDownloadUrl');

    // ✅ 2️⃣ Save Application Data in Firestore
    final jobApplication = JobApplicationModel(
      userId: userId,
      fullName: fullName,
      phone: phone,
      email: email,
      address: address,
      resumeFileName: resumeDownloadUrl, // store URL instead of just name
      appliedJob: appliedJob,
      appliedDate: DateTime.now(),
    );

    await _firestore
        .collection('job_applications')
        .doc(jobApplication.documentId)
        .set(jobApplication.toMap());

    _userApplications.add(jobApplication);
    notifyListeners();

    debugPrint("✅ Application and resume uploaded successfully!");
  } catch (e) {
    debugPrint("❌ Error uploading/submitting application: $e");
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}





  /// ✅ Fetch all job applications (Admin view)
  Stream<List<JobApplicationModel>> getAllJobApplications() {
    return _firestore
        .collection('job_applications')
        .orderBy('appliedDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => JobApplicationModel.fromMap(doc.data()))
              .toList();
        });
  } 
}
