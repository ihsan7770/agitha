import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodSelectionWidget extends StatefulWidget {
  final String restaurantId;

  /// Callback to get selected food list outside
  final Function(List<Map<String, dynamic>>) onSelectionChanged;

  const FoodSelectionWidget({
    super.key,
    required this.restaurantId,
    required this.onSelectionChanged,
  });

  @override
  State<FoodSelectionWidget> createState() => _FoodSelectionWidgetState();
}

class _FoodSelectionWidgetState extends State<FoodSelectionWidget> {
  List<Map<String, dynamic>> selectedFoods = [];

  bool isSelected(String foodId) {
    return selectedFoods.any((e) => e['foodId'] == foodId);
  }

  void toggleFood(food) {
    setState(() {
      if (isSelected(food.id)) {
        selectedFoods.removeWhere((e) => e['foodId'] == food.id);
      } else {
        selectedFoods.add({
          "foodId": food.id,
          "name": food.dishName,
          "price": food.price,
        });
      }

      /// Call callback to send updated list
      widget.onSelectionChanged(selectedFoods);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 MediaQuery for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageWidth = screenWidth * 0.16; // responsive image width
    final imageHeight = screenHeight * 0.12; // responsive image height
    final containerBorderRadius = screenWidth * 0.02;
    final containerPadding = screenWidth * 0.025;
    final spacingBetweenImageAndText = screenWidth * 0.02;
    final textFontSize = screenWidth * 0.025;
    final priceFontSize = screenWidth * 0.025;
    final gridPadding = screenWidth * 0.02;
    final gridChildAspectRatio = 2.8; // can tweak if needed

    return Column(
      children: [
        // 🔹 Food Grid
        StreamBuilder<List<dynamic>>(
          stream: UserEventProvider().restaurantFoodStream(widget.restaurantId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            final foods = snapshot.data!;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(gridPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: screenWidth * 0.02,
                crossAxisSpacing: screenWidth * 0.02,
                childAspectRatio: gridChildAspectRatio,
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                final selected = isSelected(food.id);

                return GestureDetector(
                  onTap: () => toggleFood(food),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.red.withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                      border: Border.all(
                        color: selected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// Image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(containerBorderRadius),
                            bottomLeft: Radius.circular(containerBorderRadius),
                          ),
                          child: Image.network(
                            food.imageUrl,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                NoInternetWidget(
                              width: imageWidth,
                              height: imageHeight,
                              iconSize: screenWidth * 0.06,
                              textSize: screenWidth * 0.02,
                            ),
                          ),
                        ),

                        SizedBox(width: spacingBetweenImageAndText),

                        /// Text
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(containerPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  food.dishName,
                                  style: TextStyle(
                                    fontSize: textFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "₹ ${food.price}",
                                  style: TextStyle(
                                    fontSize: priceFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),

        // 🔹 Drinks Title
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Drinks",
              style: GoogleFonts.tinos(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
            ),
          ),
        ),

        // 🔹 Drinks Grid
        StreamBuilder<List<dynamic>>(
          stream: UserEventProvider().restaurantDrinksStream(widget.restaurantId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            final foods = snapshot.data!;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(gridPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: screenWidth * 0.02,
                crossAxisSpacing: screenWidth * 0.02,
                childAspectRatio: gridChildAspectRatio,
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                final selected = isSelected(food.id);

                return GestureDetector(
                  onTap: () => toggleFood(food),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.red.withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(containerBorderRadius),
                      border: Border.all(
                        color: selected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3),
                      ],
                    ),
                    child: Row(
                      children: [
                        /// Image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(containerBorderRadius),
                            bottomLeft: Radius.circular(containerBorderRadius),
                          ),
                          child: Image.network(
                            food.imageUrl,
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                NoInternetWidget(
                              width: imageWidth,
                              height: imageHeight,
                              iconSize: screenWidth * 0.06,
                              textSize: screenWidth * 0.02,
                            ),
                          ),
                        ),

                        SizedBox(width: spacingBetweenImageAndText),

                        /// Text
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(containerPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  food.dishName,
                                  maxLines: 1,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: textFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  "₹ ${food.price}",
                                  style: TextStyle(
                                    fontSize: priceFontSize,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
