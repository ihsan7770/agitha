import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class UserEventOrderDetailsPage extends StatelessWidget {
  final String eventId;

  const UserEventOrderDetailsPage({super.key, required this.eventId});

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch call");
    }
  }

  String getDurationText(int duration) {
    if (duration == 60) return "1 Hour";
    if (duration == 120) return "2 Hours";
    if (duration == 180) return "3 Hours";
    return "$duration Minutes";
  }

  String formatTimeRange12Hour(DateTime startTime, int durationMinutes) {
    final endTime = startTime.add(Duration(minutes: durationMinutes));

    String format12(DateTime time) {
      int hour = time.hour % 12;
      hour = hour == 0 ? 12 : hour;
      final minute = time.minute.toString().padLeft(2, '0');
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    }

    return "${format12(startTime)} - ${format12(endTime)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Details"), centerTitle: true),
      body: StreamBuilder<EventModel?>(
        stream: UserEventProvider().getUserSingleEventStream(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Event not found"));
          }

          final r = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Card(
              surfaceTintColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [




               StreamBuilder<CompanyRegistrationModel?>(
  stream:UserEventProvider().getUserSingleEventCompanyDetailsStream(r.restaurantId),
  builder: (context, snapshot) {

    // ❌ No loading UI
    if (!snapshot.hasData || snapshot.data == null) {
      return const SizedBox.shrink(); // shows nothing
    }

    final r = snapshot.data!;

    return ListTile(
      leading:  CircleAvatar(
  radius: 24,
  backgroundImage: NetworkImage(r.logoUrl!),
),



      title: Text(
        r.restaurantName ?? "Guest",
        style: GoogleFonts.tinos(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        (r.phone != null && r.phone!.isNotEmpty)
            ? r.phone!
            : "No phone number",
        style: GoogleFonts.tinos(color: Colors.grey),
      ),
      trailing: (r.phone != null && r.phone!.isNotEmpty)
          ? OutlinedButton(
              onPressed: () {
                makePhoneCall(r.phone!);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 6,
                ),
              ),
              child: Text(
                "Call",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  },
),



                    

                    const Divider(height: 30),

                    detailRow("Event Type", r.eventType),
                    detailRow("Guests", r.guests.toString()),
                    detailRow("Date",
                        r.date.toLocal().toString().split(' ')[0]),
                    detailRow("Time",
                    formatTimeRange12Hour(r.time.toDate(), r.duration)),
                    detailRow("Duration", getDurationText(r.duration)),
                     if (r.decorationSuggestion == null || r.decorationSuggestion.isEmpty)
                      detailRow("Decoration Type", r.decorationType),
                    if (r.cakeData == null || r.cakeData!.isEmpty)
                     detailRow("Cake", "Without Cake"),
                      if (r.bakeryData == null ||  r.bakeryData!.isEmpty)
                     detailRow("Bakery", "Without Bakery"),

                       if (r.eventFoodData == null ||  r.eventFoodData!.isEmpty)
                     detailRow("Food", "Without Food"),




                    /// Decoration
                    if (r.decorationSuggestion != null &&
                        r.decorationSuggestion!.isNotEmpty) ...[
                      const Divider(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "Decorations",
                          style: GoogleFonts.tinos(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "User Preferences",
                          style: GoogleFonts.tinos(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          r.decorationSuggestion!,
                          style: GoogleFonts.tinos(
                              fontWeight: FontWeight.w400, 
                              fontSize: 13,
                              color: Colors.grey[700],
                               ),
                        ),
                      ),
                    ],

                    //food data

                /// ---------------- FOOD DATA ----------------
if (r.eventFoodData != null && r.eventFoodData!.isNotEmpty) ...[
  const Divider(height: 30),
  const SizedBox(height: 8),

  Text(
    "Food Items",
    style: GoogleFonts.tinos(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),

  const SizedBox(height: 6),

  ...r.eventFoodData!.map((food) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -------- FOOD ROW --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.restaurant_menu, size: 18),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food['name']?.toString() ?? "Food Item",
                      style: GoogleFonts.tinos(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    ],
                ),
              ),

              /// Price (optional)
              if (food['price'] != null)
                Text(
                  "₹${food['price']}",
                  style: GoogleFonts.tinos(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
            ],
          ),



        ],
      ),
    );
  }).toList(),

Padding(
  padding: const EdgeInsets.only(left: 8,bottom: 8),
  child: Align(
    alignment: Alignment.bottomLeft,
    child: RichText(
      text: TextSpan(
        style: GoogleFonts.tinos(
          fontSize: 13,
          color: Colors.grey[700],
        ),
        children: [
          const TextSpan(
            text: "Food Service Type: ",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: r.foodServiceType ?? "",
          ),
        ],
      ),
    ),
  ),
),

/// -------- FOOD SUGGESTIONS --------
if (r.foodSuggestion != null && r.foodSuggestion!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 10),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.tinos(
            fontSize: 13,
            color: Colors.grey[700],
          ),
          children: [
            const TextSpan(
              text: "Suggestions: ",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: r.foodSuggestion!,
            ),
          ],
        ),
      ),
    ),
  ),

    
],



//food data ends













                    /// Cakes
       if (r.cakeData != null && r.cakeData!.isNotEmpty) ...[
  const Divider(height: 3),
  const SizedBox(height: 8),

  Text(
    "Cakes",
    style: GoogleFonts.tinos(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),

  const SizedBox(height: 6),

  ...r.cakeData!.map((cake) {

    /// ---------------- PRICE SAFE EXTRACTION ----------------
    int cakePrice = 0;

    if (cake.containsKey('calculatedPrice')) {
      final value = cake['calculatedPrice'];

      if (value is int) {
        cakePrice = value;
      } else if (value is double) {
        cakePrice = value.toInt();
      } else if (value is String) {
        cakePrice = int.tryParse(value) ?? 0;
      }
    }

    int decorationPrice =
        int.tryParse(r.cakeDecorationprice?.toString() ?? '0') ?? 0;

    int totalCakePrice = cakePrice + decorationPrice;

    /// DEBUG (optional)
    // print("Cake Data => $cake");
    // print("CakePrice => $cakePrice");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ---------------- CAKE ROW ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.cake, size: 18),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cake['name']?.toString() ?? "Cake",
                      style: GoogleFonts.tinos(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Qty: ${cake['qty'] ?? 1} • Weight: ${cake['weight'] ?? '--'}",
                      style: GoogleFonts.tinos(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              /// Cake Price
              Text(
                "₹$cakePrice",
                style: GoogleFonts.tinos(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

          ),

    
          /// ---------------- TOTAL ----------------
          // Padding(
          //   padding: const EdgeInsets.only(left: 26, top: 6),
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Text(
          //       "Total Cake: ₹$totalCakePrice",
          //       style: GoogleFonts.tinos(
          //         fontSize: 14,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );


    
  }).toList(),

         
       /// ---------------- CAKE SUGGESTION ----------------
if (r.cakesuggestion != null && r.cakesuggestion!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(left: 26, top: 4),
    child: RichText(
      text: TextSpan(
        style: GoogleFonts.tinos(
          fontSize: 13,
          color: Colors.grey[700],
        ),
        children: [
          const TextSpan(
            text: "Suggestions: ",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: r.cakesuggestion!,
          ),
        ],
      ),
    ),
  ),

/// ---------------- PAID DECORATION ----------------
if (r.paidsuggestioncake != null &&
    r.paidsuggestioncake!.isNotEmpty)
  Padding(
    padding: const EdgeInsets.only(left: 26, top: 4),
    child: Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.tinos(
                fontSize: 13,
                color: Colors.grey[700],
              ),
              children: [
                const TextSpan(
                  text: "Type: ",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: r.paidsuggestioncake!,
                ),
              ],
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            style: GoogleFonts.tinos(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            children: [
              const TextSpan(text: "₹"),
              TextSpan(
                text: r.cakeDecorationprice?.toString() ?? "0",
              ),
            ],
          ),
        ),
      ],
    ),
  ),

],


                    /// Bakery
                    if (r.bakeryData != null &&
                        r.bakeryData!.isNotEmpty) ...[
                      const Divider(height: 30),
                      const SizedBox(height: 8),
                      Text(
                        "Bakery Items",
                        style: GoogleFonts.tinos(
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 6),
                      ...r.bakeryData!.map((bakery) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.cookie, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  bakery['name'] ?? "Bakery Item",
                                  style: GoogleFonts.tinos(),
                                ),
                              ),
                              Text(
                                "₹${bakery['price'] ?? ''}",
                                style: GoogleFonts.tinos(
                                    fontWeight:
                                        FontWeight.w600),
                              ),
                            ], 
                          ),
                        );
                      }).toList(),
                    ] 
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(title,
                style: GoogleFonts.tinos(
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 6,
            child: Text(value ?? "-", style: GoogleFonts.tinos()),
          ),
        ],
      ),
    );
  }
}
 