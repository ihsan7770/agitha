

// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';

// class PaymentProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   String? _errorMessage;

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   Future<bool> makePayment(int amountInRupees) async {
//     try {
//       _isLoading = true;
//       _errorMessage = null;
//       notifyListeners();

//       // Convert rupees to paise
//       int amount = amountInRupees * 100;

//       // 1️⃣ Call Firebase Function
//       final response = await http.post(
//         Uri.parse("https://createpaymentintent-l3nl4qbtxa-uc.a.run.app"),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"amount": amount}),
//       );

//       if (response.statusCode != 200) {
//         throw Exception("Failed to create payment intent");
//       }

//       final data = jsonDecode(response.body);

//       final clientSecret = data["clientSecret"] ?? data["client_secret"];
//       if (clientSecret == null) {
//         throw Exception("Client secret is null. Check your backend!");
//       }

//       // 2️⃣ Initialize payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           merchantDisplayName: "Agitha",
//           paymentIntentClientSecret: clientSecret,
//         ),
//       );

//       // 3️⃣ Show payment sheet
//       await Stripe.instance.presentPaymentSheet();

//       _isLoading = false;
//       notifyListeners();
      
//       return true;
//     } catch (e) {
//       if (e is StripeException && e.error.code == FailureCode.Canceled) {
//         _errorMessage = "User canceled the payment.";
//       } else {
//         _errorMessage = "Payment failed: $e";
//       }

//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
// }


