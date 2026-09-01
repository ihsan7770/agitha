import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:printing/printing.dart';

class EventBillPdfPage {
  static Future<void> generateAndDownloadPdf(
      Map<String, dynamic> data) async {

    final pdf = pw.Document();

    // ✅ Fonts (₹ supported)
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();

    // ✅ Background image
    final bgImage = pw.MemoryImage(
      (await rootBundle.load('assets/agithabg.jpg'))
          .buffer
          .asUint8List(),
    );

    // ---------- CALCULATIONS ----------
    double foodTotal =
        double.tryParse(data['totalFoodAmount']?.toString() ?? '0') ?? 0;

    double decorationTotal =
        double.tryParse(data['totalDecorationAmount']?.toString() ?? '0') ?? 0;

    double bakeryTotal = 0;
    if (data['bakeryItems'] != null) {
      for (var item in data['bakeryItems']) {
        bakeryTotal += double.tryParse(item['price'].toString()) ?? 0;
      }
    }

    double cakeTotal = 0;
    if (data['cakes'] != null) {
      for (var cake in data['cakes']) {
        final price = double.tryParse(cake['price'].toString()) ?? 0;
        final qty = cake['qty'] ?? 1;
        cakeTotal += price * qty;
      }
    }

    cakeTotal +=
        double.tryParse(data['cakeDecorationPrice']?.toString() ?? '0') ?? 0;

    final grandTotal =
        double.tryParse(data['grandTotal']?.toString() ?? '0') ?? 0;

    // ---------- PDF PAGE ----------
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Stack(
            children: [

              /// ---------- BACKGROUND IMAGE ----------
              pw.Center(
  child: pw.Opacity(
    opacity: 0.08, // watermark effect
    child: pw.Image(
      bgImage,
      width: 600,  // 👈 control size
      height: 600,
      fit: pw.BoxFit.contain,
    ),
  ),
),

              /// ---------- MAIN CONTENT ----------
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "EVENT BILL",
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 24,
                        ),
                      ),
                      pw.Text(
                        "₹ INVOICE",
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 10),
                  pw.Divider(),

                  /// EVENT INFO
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _infoText("Bill ID", data['eventId'], font),
                      _infoText("Event Type", data['eventType'], font),
                      _infoText("Guests", data['noGuests'], font),
                    ],
                  ),

                  pw.SizedBox(height: 16),

                  /// DECORATION
                  _sectionTitle("Decoration", boldFont),
                  _amountRow("Base Decoration",
                      data['baseDecorationAmount'], font),
                  _amountRow("Extra Decoration",
                      data['extraDecorationPrice'], font),
                  _amountRow("Decoration Total", decorationTotal, font),

                  pw.Divider(),

                  /// FOOD
                  if (data['foodItems'] != null &&
                      data['foodItems'].isNotEmpty) ...[
                    _sectionTitle("Food Items", boldFont),
                    ...data['foodItems'].map<pw.Widget>((food) {
                      final price =
                          double.tryParse(food['price'].toString()) ?? 0;
                      final qty = food['qty'] ?? 1;
                      return _amountRow(
                          "${food['name']} x$qty",
                          price * qty,
                          font);
                    }).toList(),
                    _amountRow("Food Total", foodTotal, font),
                    pw.Divider(),
                  ],

                  /// CAKES
                  if (data['cakes'] != null &&
                      data['cakes'].isNotEmpty) ...[
                    _sectionTitle("Cakes", boldFont),
                    ...data['cakes'].map<pw.Widget>((cake) {
                      final price =
                          double.tryParse(cake['price'].toString()) ?? 0;
                      final qty = cake['qty'] ?? 1;
                      return _amountRow(
                          "${cake['name']} x$qty",
                          price * qty,
                          font);
                    }).toList(),
                    _amountRow("Cake Decoration",
                        data['cakeDecorationPrice'], font),
                    _amountRow("Cake Total", cakeTotal, font),
                    pw.Divider(),
                  ],

                  /// BAKERY
                  if (data['bakeryItems'] != null &&
                      data['bakeryItems'].isNotEmpty) ...[
                    _sectionTitle("Bakery Items", boldFont),
                    ...data['bakeryItems'].map<pw.Widget>((bakery) {
                      return _amountRow(
                          bakery['name'],
                          bakery['price'],
                          font);
                    }).toList(),
                    _amountRow("Bakery Total", bakeryTotal, font),
                    pw.Divider(),
                  ],

                  pw.SizedBox(height: 10),

                  /// GRAND TOTAL
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "GRAND TOTAL",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 16,
                          ),
                        ),
                        pw.Text(
                          "₹ ${grandTotal.toStringAsFixed(2)}",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Spacer(),

                  /// FOOTER
                  pw.Center(
                    child: pw.Text(
                      "Thank you for choosing our service",
                      style: pw.TextStyle(font: font, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // ---------- SAVE ----------
    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final path =
        "${directory.path}/Event_Bill_${data['eventId']}.pdf";

    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    // ---------- OPEN ----------
    await OpenFilex.open(path);
  }

  /// ---------- HELPERS ----------
  static pw.Widget _sectionTitle(String title, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          font: font,
          fontSize: 14,
        ),
      ),
    );
  }

  static pw.Widget _amountRow(
      String title, dynamic amount, pw.Font font) {
    final value =
        double.tryParse(amount?.toString() ?? '0') ?? 0;
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(title, style: pw.TextStyle(font: font)),
        pw.Text(
          "₹ ${value.toStringAsFixed(2)}",
          style: pw.TextStyle(font: font),
        ),
      ],
    );
  }

  static pw.Widget _infoText(
      String label, dynamic value, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(font: font, fontSize: 10),
        ),
        pw.Text(
          value?.toString() ?? "-",
          style: pw.TextStyle(font: font),
        ),
      ],
    );
  }
}
