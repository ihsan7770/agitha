import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

 Future<void> sendOTP({
  required String phoneNumber,
  required Function(String verificationId) onCodeSent,
  required Function(String error) onError,
}) async {
  try {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),

      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("✅ Auto verification completed");
      },

      verificationFailed: (FirebaseAuthException e) {
        print("❌ OTP Verification Failed");
        print("Code: ${e.code}");
        print("Message: ${e.message}");

        onError(e.message ?? "Verification failed");
      },

      codeSent: (String verificationId, int? resendToken) {
        print("📩 OTP Sent Successfully");
        print("Verification ID: $verificationId");
        print("Resend Token: $resendToken");

        onCodeSent(verificationId);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        print("⏰ Auto-retrieval timeout");
      },
    );
  } catch (e) {
    print("🔥 Unexpected Error: $e");
    onError("Something went wrong. Try again.");
  }
}



}
