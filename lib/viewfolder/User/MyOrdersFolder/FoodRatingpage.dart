import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/FoodRatingController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:agitha/ModelsFoder/FoodRating.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';

import 'package:agitha/viewfolder/Widgets/ProfileAlert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';

class FoodItemPage extends StatefulWidget {
  final String dishid;

  const FoodItemPage({
    super.key,
    required this.dishid,
  });

  @override
  State<FoodItemPage> createState() => _FoodItemPageState();
}

class _FoodItemPageState extends State<FoodItemPage> {
  final TextEditingController reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? _selectedRating;

  final List<String> _faces = ["😡", "😞", "😐", "😊", "😍"];
  final List<String> _labels = ["Terrible", "Bad", "Okay", "Good", "Excellent"];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Food Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<Map<String, dynamic>?>(
          stream: OrderController().foodByDishIdStream(widget.dishid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Food item not found"));
            }

            final food = snapshot.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      Image.network(
                        food['imageUrl'],
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),

                      const SizedBox(height: 12),

                      /// TITLE + PRICE
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              food['dishName'],
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "₹${food['price']}",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// RATING CHIP
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                (food['rating'] as num).toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// DESCRIPTION
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          food['describtion'],
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// RATE EXPERIENCE
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Rate your experience",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// EMOJI RATING (inside the same StatefulBuilder)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_faces.length, (index) {
                            final faceValue = index + 1;
                            final isSelected = _selectedRating == faceValue;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRating = faceValue;
                                });
                              },
                              child: Column(
                                children: [
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                        fontSize: isSelected ? 50 : 30),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(_faces[index]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Text(_labels[index],
                                        style: const TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, bottom: 10.0, top: 30.0),
                        child: Text(
                          "Tell us what you think ?",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      /// REVIEW INPUT
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: reviewController,
                            validator: (v) =>
                                v!.isEmpty ? "Enter your review" : null,
                            decoration: InputDecoration(
                              hintText: "Write your review...",
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: colorScheme.primary, width: 2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              suffixIcon: Consumer<FoodRatingProvider>(
                                builder: (context, provider, _) {
                                  return IconButton(
                                    icon: provider.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        :  Icon(Icons.send,color:colorScheme.primary,),
                                    onPressed: provider.isLoading
                                        ? null // ⛔ disable while loading
                                        : () async {
                                            // ❌ No emoji selected
                                            if (_selectedRating == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Please select a rating 😊"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                              return;
                                            }

                                            // ❌ Review empty
                                            if (!_formKey.currentState!
                                                .validate()) return;

                                            final model = FoodRatingModel(
                                              docId: "",
                                              restaurantId: food['restaurantId'],
                                              dishid: widget.dishid,
                                              foodname: food['dishName'],
                                              profileImageUrl: "",
                                              username: "",
                                              rating:
                                                  _selectedRating!.toDouble(),
                                              review: reviewController.text
                                                  .trim(),
                                            );

                                            await provider.AddFoodRating(model);

                                            // ⚠️ Optional: causes rebuild jump
                                            await provider
                                                .updateAverageRating(
                                                    widget.dishid);

                                            // ✅ Clear the rating and trigger UI update
                                            setState(() {
                                              _selectedRating = null;
                                            });

                                            reviewController.clear();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Thanks for your feedback ❤️"),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}