import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousEventMoreDetail extends StatefulWidget {
  final String? eventId;

  const PreviousEventMoreDetail({
    super.key,
    required this.eventId,
  });

  @override
  State<PreviousEventMoreDetail> createState() =>
      _PreviousEventMoreDetailState();
}

class _PreviousEventMoreDetailState extends State<PreviousEventMoreDetail> {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<RestaurantEventController>(context, listen: false);

    /// ✅ MediaQuery (SAME SCALE AS buildSameCard)
    final double width = MediaQuery.of(context).size.width;

    final double titleSize   = width * 0.04;  // = 18 on normal phones
    final double sectionSize = width * 0.045; // section headings
    final double normalSize  = width * 0.035; // normal rows
    final double boldSize    = width * 0.035;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Bill Details",
        
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: provider.getEventBillStream(widget.eventId!),
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
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ---------------- BASIC INFO ----------------
                _infoRow("Event ID", widget.eventId, normalSize, boldSize),
                _infoRow("Event Type", data['eventType'], normalSize, boldSize),
                _infoRow("Guests", data['noGuests'], normalSize, boldSize),
                const Divider(),

                /// ---------------- DECORATION ----------------
                _section("Decoration", sectionSize),
                _infoRow("Base Amount",
                    "₹ ${data['baseDecorationAmount'] ?? 0}",
                    normalSize, boldSize),
                _infoRow("Extra Decoration",
                    "₹ ${data['extraDecorationPrice'] ?? 0}",
                    normalSize, boldSize),
                _infoRow("Total Decoration",
                    "₹ ${data['totalDecorationAmount'] ?? 0}",
                    normalSize, boldSize),
                const Divider(),

                /// ---------------- FOOD ----------------
                _section("Food Items", sectionSize),
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
                        normalSize,
                      );
                    },
                  ),
                _infoRow("Total Food Price",
                    "₹ ${data['totalFoodAmount'] ?? 0}",
                    normalSize, boldSize),
                const Divider(),

                /// ---------------- CAKES ----------------
                if (data['cakes'] != null && data['cakes'].isNotEmpty) ...[
                  _section("Cakes", sectionSize),
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
                        normalSize,
                      );
                    },
                  ),
                  _infoRow("Cake Type", data['cakeType'] ?? "-",
                      normalSize, boldSize),
                  _infoRow("Cake Decoration",
                      "₹ ${cakeDecoration.toStringAsFixed(0)}",
                      normalSize, boldSize),
                  _infoRow("Cake Total",
                      "₹ ${finalCakeTotal.toStringAsFixed(0)}",
                      normalSize, boldSize),
                  const Divider(),
                ],

                /// ---------------- BAKERY ----------------
                if (data['bakeryItems'] != null &&
                    data['bakeryItems'].isNotEmpty) ...[
                  _section("Bakery Items", sectionSize),
                  ...List.generate(
                    data['bakeryItems'].length,
                    (index) {
                      final bakery = data['bakeryItems'][index];
                      final double price =
                          double.tryParse(bakery['price'].toString()) ?? 0;

                      return _itemRow(
                        bakery['name'] ?? '-',
                        "₹ ${price.toStringAsFixed(0)}",
                        normalSize,
                      );
                    },
                  ),
                  _infoRow("Bakery Total",
                      "₹ ${bakeryTotal.toStringAsFixed(0)}",
                      normalSize, boldSize),
                  const Divider(),
                ],

                /// ---------------- GRAND TOTAL ----------------
                Padding(
                  padding: EdgeInsets.symmetric(vertical: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Grand Total",
                        style: GoogleFonts.tinos(
                          fontSize: sectionSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹ ${data['grandTotal'] ?? 0}",
                        style: GoogleFonts.tinos(
                          fontSize: sectionSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ---------------- HELPERS ----------------

  Widget _section(String text, double size) {
    return Text(
      text,
      style: GoogleFonts.tinos(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoRow(
      String title, dynamic value, double normalSize, double boldSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.tinos(
              fontSize: normalSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value?.toString() ?? "-",
            style: GoogleFonts.tinos(
              fontSize: boldSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(String name, String price, double normalSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: GoogleFonts.tinos(fontSize: normalSize)),
          Text(price, style: GoogleFonts.tinos(fontSize: normalSize)),
        ],
      ),
    );
  }
}
