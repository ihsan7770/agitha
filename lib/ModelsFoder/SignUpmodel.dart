import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpModel {
  final String uid;
  final String email;
  final String phone;
  final String role;
  final Timestamp createdAt;

  SignUpModel({
    required this.uid,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "phone": phone,
      "role": role,
      "createdAt": createdAt,
    };
  }

  factory SignUpModel.fromMap(Map<String, dynamic> map) {
    return SignUpModel(
      uid: map["uid"] ?? "",
      email: map["email"] ?? "",
      phone: map["phone"] ?? "",
      role: map["role"] ?? "",
      createdAt: map["createdAt"] ?? Timestamp.now(),
    );
  }
}
