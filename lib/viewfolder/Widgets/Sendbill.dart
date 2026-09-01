import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:printing/printing.dart';

Future<File> generateBillPdfFromFoodData({
  required List<Map<String, dynamic>> foodData,
  required String restaurantName,
  required String reservationId,
  required String reservationFee,
}) async {
  debugPrint("📄 Starting PDF generation...");

  try {
    // ✅ CORRECT FONT (₹ supported)
    final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();

    // ✅ Load watermark image
    final bgImage = pw.MemoryImage(
      (await rootBundle.load("assets/agithabg.jpg"))
          .buffer
          .asUint8List(),
    );

    final pdf = pw.Document();
    double grandTotal = 0;
    double payableAmount = 0;

    final tableRows = <List<String>>[];

    for (var food in foodData) {
      final name = food['dish']?.toString() ?? 'Unknown Item';
      final price = (food['price'] ?? 0).toDouble();
      final qty = (food['qty'] ?? 1).toInt();
      final total = price * qty;
      grandTotal += total;

      tableRows.add([
        name,
        "₹${price.toStringAsFixed(0)}",
        qty.toString(),
        "₹${total.toStringAsFixed(0)}",
      ]);
    }

    final reservationFeeAmount = double.tryParse(reservationFee) ?? 0;
    payableAmount = grandTotal - reservationFeeAmount;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Stack(
            children: [

              /// ---------- CENTER WATERMARK ----------
              pw.Center(
                child: pw.Opacity(
                  opacity: 0.07,
                  child: pw.Image(
                    bgImage,
                    width: 600,
                    height: 600,
                    fit: pw.BoxFit.contain,
                  ),
                ),
              ),

              /// ---------- CONTENT ----------
              pw.DefaultTextStyle(
                style: pw.TextStyle(font: font),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    pw.Text(
                      restaurantName,
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 20,
                      ),
                    ),

                    pw.SizedBox(height: 8),
                    pw.Text("Reservation ID: $reservationId"),
                    pw.SizedBox(height: 16),
                    pw.Divider(),

                    pw.Text(
                      "Bill Details",
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 16,
                      ),
                    ),

                    pw.SizedBox(height: 12),

                    pw.Table.fromTextArray(
                      headers: ["Item", "Price", "Qty", "Total"],
                      data: tableRows,
                      headerStyle: pw.TextStyle(
                        font: boldFont,
                        fontSize: 12,
                      ),
                      cellStyle: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                      ),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3),
                        1: const pw.FlexColumnWidth(1.5),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FlexColumnWidth(1.5),
                      },
                    ),

                    pw.SizedBox(height: 16),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Reservation Fee:"),
                        pw.Text(
                          "₹$reservationFee",
                          style: pw.TextStyle(font: boldFont),
                        ),
                      ],
                    ),

                    pw.Divider(),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Grand Total",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 14,
                          ),
                        ),
                        pw.Text(
                          "₹${grandTotal.toStringAsFixed(0)}",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 10),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "Payable Amount",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 16,
                          ),
                        ),
                        pw.Text(
                          "₹${payableAmount.toStringAsFixed(0)}",
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 16,
                            color: PdfColors.green,
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 30),
                    pw.Center(
                      child: pw.Text("Thank you for dining with us!"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        "${dir.path}/bill_${DateTime.now().millisecondsSinceEpoch}_$reservationId.pdf";

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(filePath);
    return file;
  } catch (e, stack) {
    debugPrint("❌ Error generating PDF: $e");
    debugPrint("📛 Stack: $stack");
    rethrow;
  }
}
