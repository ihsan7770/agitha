import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/ModelsFoder/StripePaymentClass.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/OrderStatusPage.dart';
import 'package:agitha/viewfolder/Widgets/PaymentSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FoodPaymentPage extends StatefulWidget {
  final String latestOrderId;
  const FoodPaymentPage({super.key, required this.latestOrderId});

  @override
  State<FoodPaymentPage> createState() => _FoodPaymentPageState();
}

class _FoodPaymentPageState extends State<FoodPaymentPage> {
  String? _selectedPaymentMethod;

  /// 🔒 ALWAYS DOUBLE (never int)
  double _selectedTip = 0.0;
  bool _isCustomSelected = false;

  final TextEditingController _customTipController = TextEditingController();

  @override
  void dispose() {
    _customTipController.dispose();
    super.dispose();
  }

  /// 🔴 COMMON BACK FUNCTION
  Future<bool> _onBackPressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Order"),
        content: const Text(
            "Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success =
          await Provider.of<OrderController>(context,
                  listen: false)
              .cancelOrder(widget.latestOrderId);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Order cancelled successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const FoodCartPage()),
        );
      }
    }

    return false; // ❗ Prevent default back
  }


  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    // final paymentProvider = Provider.of<PaymentProvider>(context);
    final orderProvider = Provider.of<OrderController>(context);
    final colorScheme = Theme.of(context).colorScheme;

    final double totalAmount = cartController.totalPrice + _selectedTip;

    return WillPopScope(
      onWillPop:  _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔥 Payment Summary
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 75, 2, 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${cartController.uniqueItemsCount} items | To Pay",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "₹${totalAmount.toStringAsFixed(2)}",
                          style: GoogleFonts.tinos(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Includes tip: ₹${_selectedTip.toStringAsFixed(2)}",
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      
              /// 💝 Tip Section
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Add a Tip",
                    style: GoogleFonts.tinos(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),
      
              Wrap(
                spacing: 10,
                children: [
                  ...[10, 20, 30].map((tip) {
                    final bool selected = _selectedTip == tip.toDouble();
      
                    return ChoiceChip(
                      label: Text("₹$tip"),
                      selected: selected,
                      selectedColor: colorScheme.primary,
                      side: const BorderSide(
                        color: Colors.grey, // 👈 border color
                        width: 1,
                      ),
                      checkmarkColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, // 👈 width
                        vertical: 10, // 👈 height
                      ),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black54,
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selectedTip = value ? tip.toDouble() : 0.0;
                          _isCustomSelected = false;
                        });
                      },
                    );
                  }),
      
                  /// 🔹 Custom Tip Chip
                  ChoiceChip(
                    label: Text(
                      _isCustomSelected ? "₹${_selectedTip.toInt()}" : "More",
                    ),
                    selected: _isCustomSelected,
                    side: const BorderSide(
                      color: Colors.grey, // 👈 border color
                      width: 1,
                    ),
                    selectedColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20, // 👈 width
                      vertical: 10, // 👈 height
                    ),
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: _isCustomSelected ? Colors.white : Colors.black54,
                    ),
                    onSelected: (value) async {
                      if (!value) {
                        setState(() {
                          _isCustomSelected = false;
                          _selectedTip = 0.0;
                        });
                        return;
                      }
      
                      _customTipController.clear();
      
                      final num? result = await showDialog<num>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Enter Tip Amount"),
                            content: TextField(
                              controller: _customTipController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                prefixText: "₹ ",
                                hintText: "Enter amount",
      
                                /// ✅ Outlined border
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
      
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
      
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  final value =
                                      int.tryParse(_customTipController.text);
      
                                  if (value == null || value <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Please enter a valid amount"),
                                      ),
                                    );
                                    return;
                                  }
      
                                  /// 🚫 Already available in chips
                                  if ([10, 20, 30].contains(value)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "₹$value is already available in tip options",
                                        ),
                                      ),
                                    );
                                    return;
                                  }
      
                                  Navigator.pop(context, value.toDouble());
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
      
                      if (result != null && result > 0) {
                        setState(() {
                          _selectedTip = result.toDouble();
                          _isCustomSelected = true;
                        });
                      }
                    },
                  ),
                ],
              ),
      
              /// 💳 Payment Method
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Payment Method",
                    style: GoogleFonts.tinos(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      
              RadioListTile<String>(
                  value: "Card",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) =>
                      setState(() => _selectedPaymentMethod = value),
                  title: ListTile(
                    title: const Text("Credit / Debit Card"),
                    subtitle: const Text(
                      "Pay using Stripe",
                      style: TextStyle(color: Colors.grey),
                    ),
                    leading: Image.asset("assets/payicon/card.png", height: 30),
                  )),
      
              RadioListTile<String>(
                  value: "COD",
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) =>
                      setState(() => _selectedPaymentMethod = value),
                  title: ListTile(
                    title: const Text("COD"),
                    subtitle: const Text(
                      "Cash on Delivery",
                      style: TextStyle(color: Colors.grey),
                    ),
                    leading: Image.asset("assets/payicon/cod.png", height: 40),
                  )),
            ],
          ),
        ),




        bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(16),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: orderProvider.isLoading
          ? null
          : () async {

              if (_selectedPaymentMethod == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select a payment method"),
                  ),
                );
                return;
              }

              try {

                /// ✅ If COD
                if (_selectedPaymentMethod == "COD") {

                  await orderProvider.updatePaymentStatus(
                    widget.latestOrderId,
                    "COD",
                    _selectedTip,
                  );

                } else {

                  /// ✅ Show Dummy Payment Sheet
                  await showDummyPaymentSheet(
                    context,
                    totalAmount.toDouble(),
                  );

                  /// After dummy success → mark paid
                  await orderProvider.updatePaymentStatus(
                    widget.latestOrderId,
                    "paid",
                    _selectedTip,
                  );
                }

                await cartController.clearCartOnLogout();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderStatousPage(),
                  ),
                );

              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
      child: orderProvider.isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              "Place Order",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
    ),
  ),
),


        // bottomNavigationBar: Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: SizedBox(
        //     width: double.infinity,
        //     child: ElevatedButton(
        //       style: ElevatedButton.styleFrom(
        //         backgroundColor: colorScheme.primary,
        //         padding: const EdgeInsets.symmetric(vertical: 14),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(12),
        //         ),
        //       ),
        //       onPressed: paymentProvider.isLoading || orderProvider.isLoading
        //           ? null
        //           : () async {
        //               if (_selectedPaymentMethod == null) {
        //                 ScaffoldMessenger.of(context).showSnackBar(
        //                   const SnackBar(
        //                     content: Text("Please select a payment method"),
        //                   ),
        //                 );
        //                 return;
        //               }
      
        //               try {
        //                 if (_selectedPaymentMethod == "COD") {
        //                   await orderProvider.updatePaymentStatus(
        //                     widget.latestOrderId,
        //                     "COD",
        //                     _selectedTip,
        //                   );
        //                 } else {
        //                   final success = await paymentProvider.makePayment(
        //                     totalAmount.toInt(),
        //                   );
      
        //                   if (!success) return;
      
        //                   await orderProvider.updatePaymentStatus(
        //                     widget.latestOrderId,
        //                     "paid",
        //                     _selectedTip,
        //                   );
        //                 }
      
        //                 await cartController.clearCartOnLogout();
      
        //                 Navigator.pushReplacement(
        //                   context,
        //                   MaterialPageRoute(
        //                     builder: (_) => const OrderStatousPage(),
        //                   ),
        //                 );
        //               } catch (e) {
        //                 ScaffoldMessenger.of(context).showSnackBar(
        //                   SnackBar(content: Text("Error: $e")),
        //                 );
        //               }
        //             },
        //       child: paymentProvider.isLoading
        //           ? const CircularProgressIndicator(color: Colors.white)
        //           : const Text(
        //               "Place Order",
        //               style: TextStyle(color: Colors.white, fontSize: 18),
        //             ),
        //     ),
        //   ),
        // ),



      ),
    );
  }
}
