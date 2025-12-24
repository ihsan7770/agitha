import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class JobApplicationModel {
  final String documentId; // ✅ Unique document ID
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String address;
  final String resumeFileName;
  final String appliedJob;
  final DateTime appliedDate;

  JobApplicationModel({
    String? documentId, // optional, auto-generated if null
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
    required this.resumeFileName,
    required this.appliedJob,
    required this.appliedDate,
  }) : documentId = documentId ?? const Uuid().v4(); // 🔥 Generate UUID if not passed

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'userId': userId,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'resumeFileName': resumeFileName,
      'appliedJob': appliedJob,
      'appliedDate': appliedDate,
    };
  }

  factory JobApplicationModel.fromMap(Map<String, dynamic> map) {
    return JobApplicationModel(
      documentId: map['documentId'],
      userId: map['userId'],
      fullName: map['fullName'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      resumeFileName: map['resumeFileName'],
      appliedJob: map['appliedJob'],
      appliedDate: (map['appliedDate'] as Timestamp).toDate(),
    );
  }
}
