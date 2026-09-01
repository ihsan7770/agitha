import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

Future<bool> showDummyPaymentSheet(
  BuildContext context,
  double amount,
) async {
  return await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return _PaymentSheetContent(amount: amount);
        },
      ) ??
      false; // if user closes sheet
}

class _PaymentSheetContent extends StatefulWidget {
  final double amount;

  const _PaymentSheetContent({required this.amount});

  @override
  State<_PaymentSheetContent> createState() => _PaymentSheetContentState();
}

class _PaymentSheetContentState extends State<_PaymentSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _cardHolderController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            /// Title
            const Center(
              child: Text(
                "Pay with Card",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Amount
            Center(
              child: Column(
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "₹ ${widget.amount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Card Information",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            /// Card Number
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Card Number",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter card number";
                } 
                if (value.replaceAll(' ', '').length != 16) {
                  return "Card number must be 16 digits";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            /// Expiry and CVC
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "MM/YY",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter expiry date";
                      }
                      final regex = RegExp(r'^\d{2}/\d{2}$');
                      if (!regex.hasMatch(value)) {
                        return "Invalid format MM/YY";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _cvcController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "CVC",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter CVC";
                      }
                      if (value.length != 3) {
                        return "CVC must be 3 digits";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Cardholder Name
            TextFormField(
              controller: _cardHolderController,
              decoration: InputDecoration(
                hintText: "Cardholder Name",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter cardholder name";
                }
                return null;
              },
            ),
            const SizedBox(height: 25),

            /// Pay Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 7, 231, 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.white, // white background for contrast
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side:  BorderSide(color: Theme.of(context).colorScheme.primary, width: 2), // green outline
    ),
    content: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            "Payment Successful",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 2),
  ),
);
   


                  }
                },
                child: Text(
                  "Pay ₹ ${widget.amount.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}