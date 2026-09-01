import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? _verificationId;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  /// 📲 Send OTP
  Future<String> sendOtp({required String phone}) async {
    _setLoading(true);

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification (Android)
          await _auth.signInWithCredential(credential);
        },

        verificationFailed: (FirebaseAuthException e) {
          throw e.message ?? "Verification failed";
        },

        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      _setLoading(false);
      return "success";
    } catch (e) {
      _setLoading(false);
      return e.toString();
    }
  }

  /// 🔐 Verify OTP
  Future<String> verifyOtp({required String otp}) async {
    _setLoading(true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      _setLoading(false);
      return "success";
    } catch (e) {
      _setLoading(false);
      return "Invalid OTP";
    }
  }

//otp resent 
Future<void> resendOTP(String phoneNumber) async {
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,

    verificationCompleted: (PhoneAuthCredential credential) async {
      // Auto verification (Android)
      await _auth.signInWithCredential(credential);
    },

    verificationFailed: (FirebaseAuthException e) {
      print("Verification Failed: ${e.message}");
    },

    codeSent: (String verificationId, int? resendToken) {
      print("OTP Sent Successfully");
      _verificationId = verificationId;
    },

    codeAutoRetrievalTimeout: (String verificationId) {
      _verificationId = verificationId;
    },
  );
}


Future<String> updatePasswordOnly({
  required String password,
}) async {
  debugPrint("🚀 updatePasswordOnly STARTED");
  _setLoading(true);

  try {
    final user = _auth.currentUser;
    debugPrint("👤 Current user: ${user?.uid}");

    if (user == null) {
      throw "User not authenticated";
    }

    debugPrint("🔑 Updating password...");
    await user.updatePassword(password);
    debugPrint("✅ Password updated successfully");

    debugPrint("🚪 Signing out user...");
    await _auth.signOut();
    debugPrint("✅ User signed out");

    _setLoading(false);
    return "success";
  } on FirebaseAuthException catch (e) {
    debugPrint("🔥 FirebaseAuthException: ${e.code}");
    debugPrint("🧾 Message: ${e.message}");
    _setLoading(false);
    return e.message ?? "Something went wrong";
  } catch (e) {
    debugPrint("💥 Unknown error: $e");
    _setLoading(false);
    return e.toString();
  }
}

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      _setLoading(true); // 🔵 START LOADING

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    } catch (e) {
      debugPrint("❌ Password reset error: $e");
      rethrow;
    } finally {
      _setLoading(false); // 🔴 STOP LOADING
    }
  }


 

}
