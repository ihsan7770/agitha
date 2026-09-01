import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/viewfolder/Widgets/SendEventBill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserEventBillPage extends StatelessWidget {
   final String? eventId;
  const UserEventBillPage({super.key,required this.eventId});

  @override
  Widget build(BuildContext context) {
      final provider =
        Provider.of<UserEventProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Bill Details"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: provider.getUserEventBillStream(eventId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No bill data found"));
          }

          final data = snapshot.data!.docs.first.data();

          /// ---------------- BAKERY TOTAL ----------------
          double bakeryTotal = 0;
          if (data['bakeryItems'] != null && data['bakeryItems'] is List) {
            for (var item in data['bakeryItems']) {
              bakeryTotal +=
                  double.tryParse(item['price'].toString()) ?? 0;
            }
          }

          /// ---------------- CAKE TOTAL ----------------
          double cakeBaseTotal = 0;

          if (data['cakes'] != null && data['cakes'] is List) {
            for (var cake in data['cakes']) {
              final double price =
                  double.tryParse(cake['price'].toString()) ?? 0;
              final int qty = cake['qty'] ?? 1;

              cakeBaseTotal += price * qty;
            }
          }

          final double cakeDecoration =
              double.tryParse(
                      data['cakeDecorationPrice']?.toString() ?? '0') ??
                  0;

          final double finalCakeTotal =
              cakeBaseTotal + cakeDecoration;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ---------------- BASIC INFO ----------------
               Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        
        children: [
          Text(
            "Bill Id: ",
            style: GoogleFonts.tinos(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color:Colors.grey
            ),
          ),
          Text(
            data['eventId'],
            style: GoogleFonts.tinos(
                fontSize: 8,
                 fontWeight: FontWeight.w400,
                 color:Colors.grey
                 
                 
                 ),
          ),
        ],
      ),
    ),
                _infoRow("Event Type", data['eventType']),
                _infoRow("Guests", data['noGuests']),
                const Divider(),

                /// ---------------- DECORATION ----------------
                Text("Decoration", style: _sectionTitle()),
                _infoRow("Base Amount",
                    "₹ ${data['baseDecorationAmount'] ?? 0}"),
                _infoRow("Extra Decoration",
                    "₹ ${data['extraDecorationPrice'] ?? 0}"),
                _infoRow("Total Decoration",
                    "₹ ${data['totalDecorationAmount'] ?? 0}"),
                const Divider(),

                /// ---------------- FOOD ----------------
                Text("Food Items", style: _sectionTitle()),
                if (data['foodItems'] != null)
                  ...List.generate(
                    data['foodItems'].length,
                    (index) {
                      final food = data['foodItems'][index];
                      final double price =
                          double.tryParse(food['price'].toString()) ?? 0;
                      final int qty = food['qty'] ?? 1;

                      return _itemRow(
                        "${food['name']} x$qty",
                        "₹ ${(price * qty).toStringAsFixed(0)}",
                      );
                    },
                  ),
                _infoRow("Total Food Price",
                    "₹ ${data['totalFoodAmount'] ?? 0}"),
                const Divider(),

                /// ---------------- CAKES ----------------
                if (data['cakes'] != null && data['cakes'].isNotEmpty) ...[
                  Text("Cakes", style: _sectionTitle()),
                  ...List.generate(
                    data['cakes'].length,
                    (index) {
                      final cake = data['cakes'][index];
                      final double price =
                          double.tryParse(cake['price'].toString()) ?? 0;
                      final int qty = cake['qty'] ?? 1;

                      return _itemRow(
                        "${cake['name']} x$qty",
                        "₹ ${(price * qty).toStringAsFixed(0)}",
                      );
                    },
                  ),
                  _infoRow("Cake Type", data['cakeType'] ?? "-"),
                  _infoRow("Cake Decoration",
                      "₹ ${cakeDecoration.toStringAsFixed(0)}"),
                  _infoRow("Cake Total",
                      "₹ ${finalCakeTotal.toStringAsFixed(0)}"),
                  const Divider(),
                ],

                /// ---------------- BAKERY ----------------
                if (data['bakeryItems'] != null &&
                    data['bakeryItems'].isNotEmpty) ...[
                  Text("Bakery Items", style: _sectionTitle()),
                  ...List.generate(
                    data['bakeryItems'].length,
                    (index) {
                      final bakery = data['bakeryItems'][index];
                      final double price =
                          double.tryParse(bakery['price'].toString()) ?? 0;

                      return _itemRow(
                        bakery['name'] ?? '-',
                        "₹ ${price.toStringAsFixed(0)}",
                      );
                    },
                  ),
                  _infoRow("Bakery Total",
                      "₹ ${bakeryTotal.toStringAsFixed(0)}"),
                  const Divider(),
                ],

                /// ---------------- GRAND TOTAL ----------------
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total",
                        style: GoogleFonts.tinos(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹ ${data['grandTotal'] ?? 0}",
                        style: GoogleFonts.tinos(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),


               Align(
                alignment: Alignment.topRight,
                 child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                 backgroundColor:
                               Theme.of(context).colorScheme.primary,
                               foregroundColor: Colors.white,
                         ),
                   onPressed: () async {
                     await EventBillPdfPage.generateAndDownloadPdf(data);
                   },
                   child: const Text("Download PDF"),
                 ),
               ),



                


              ],
            ),
          );
        },
      ),
    );
  }

  /// ---------------- UI HELPERS ----------------
  TextStyle _sectionTitle() => GoogleFonts.tinos(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  Widget _infoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.tinos(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value?.toString() ?? "-",
            style: GoogleFonts.tinos(
                fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(String name, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.tinos(fontSize: 14)),
          Text(price, style: GoogleFonts.tinos(fontSize: 14)),
        ],
      ),
    );
  }
}