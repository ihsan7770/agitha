import 'package:agitha/ControllersFolder/AddFoodController.dart';
import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/FoodRating_ReviewDetails.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NormalFoodItems extends StatefulWidget {
  const NormalFoodItems({super.key});

  @override
  State<NormalFoodItems> createState() => _NormalFoodItemsState();
}

class _NormalFoodItemsState extends State<NormalFoodItems> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final foodController =
        Provider.of<Addfoodprovider>(context, listen: false);

    return Scaffold(
      body: StreamBuilder<List<FoodItemModel>>(
        stream: foodController.streamNormalFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No normal food items found"));
          }

          final foodItems = snapshot.data!;

          return ListView.builder(

            padding: EdgeInsets.all(screenWidth * 0.03),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];

              return Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 16,
                        offset: const Offset(4, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            food.imageUrl,
                            width: screenWidth * 0.20,
                            height: screenWidth * 0.20,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                NoInternetWidget(
                              width: screenWidth * 0.20,
                              height: screenWidth * 0.20,
                              iconSize: screenWidth * 0.06,
                              textSize: screenWidth * 0.025,
                            ),
                          ),
                        ),

                        SizedBox(width: screenWidth * 0.03),

                        /// CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE + RATING
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      food.dishName,
                                      style: GoogleFonts.tinos(
                                        fontSize: screenWidth * 0.055,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FoodRating_ReviewPage(
                                            fooddocId: food.id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.025,
                                        vertical: screenHeight * 0.006,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.04),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: screenWidth * 0.045,
                                          ),
                                          SizedBox(
                                              width: screenWidth * 0.01),
                                          Text(
                                            food.rating.toStringAsFixed(1),
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize:
                                                  screenWidth * 0.035,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.005),

                              /// PRICE
                              Text(
                                "Price: ${food.price}",
                                style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              /// MORE OPTIONS
                              Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  tilePadding: EdgeInsets.zero,
                                  title: Text(
                                    "More Options",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.038,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        food.describtion,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.032,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.015),

                                    /// BUTTONS
                                    Row(
                                      children: [
                                        OutlinedButton(
                                          
                                          style: OutlinedButton.styleFrom(
                                           side: BorderSide(
                                             color: Theme.of(context).colorScheme.primary, // 🔥 theme border color
                                             width: 1.5,
                                           ),
                                       
                                         ),
                                          
                                          
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AddFoodItem(
                                                  isUpdate: true,
                                                  dishName: food.dishName,
                                                  price: food.price,
                                                  category: food.category,
                                                  imagePath: food.imageUrl,
                                                  foodid: food.id,
                                                  describtion:
                                                      food.describtion,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Update",
                                            style: TextStyle(
                                                fontSize:
                                                    screenWidth * 0.035),
                                          ),
                                        ),
                                        SizedBox(
                                            width: screenWidth * 0.05),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                title: const Text("Delete"),
                                                content: const Text(
                                                    "Are you sure you want to delete this food item?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child:
                                                        const Text("Cancel"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Theme.of(context).colorScheme.primary,
                                                        foregroundColor: Colors.white
                                                  ),
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      await foodController
                                                          .deleteFoodItem(
                                                              food.id,
                                                              context);
                                                    },
                                                    child:
                                                        const Text("Delete"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                fontSize:
                                                    screenWidth * 0.035),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            
          );
        },
      ),
    );
  }
}
