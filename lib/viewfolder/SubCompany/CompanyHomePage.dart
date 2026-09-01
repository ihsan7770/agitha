import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/RestourentHomeController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/FoodItemTabBar.dart';
import 'package:agitha/viewfolder/SubCompany/CakeDecorationDetails.dart/CakeDecorationForm.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/CompanyViewDeliveryBoy.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyProfileFolder/CompanyProfile.dart';
import 'package:agitha/viewfolder/SubCompany/DecorationFolder.dart/DecorationFormPage.dart';
import 'package:agitha/viewfolder/SubCompany/RestaurantRating_ReviewDetails.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
 @override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    body: StreamBuilder<CompanyRegistrationModel?>(
      stream: context.read<RestaurantHomeProvider>().restaurantStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No restaurant data found"));
        }

        final restaurant = snapshot.data!;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 Banner Image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(screenWidth * 0.06),
                  bottomRight: Radius.circular(screenWidth * 0.06),
                ),
                child: Image.network(
                  restaurant.restaurantImageUrl,
                  height: screenHeight * 0.28,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      NoInternetWidget(
                        width: double.infinity,
                        height: screenHeight * 0.28,
                        iconSize: screenWidth * 0.08,
                        textSize: screenWidth * 0.035,
                      ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              /// 🔥 Restaurant Info
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.1,
                      backgroundImage: NetworkImage(restaurant.logoUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.restaurantName,
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.055,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                        ),
                        Text(
                          restaurant.brandType,
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star,
                                color: Colors.orange,
                                size: screenWidth * 0.045),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              restaurant.rating.toStringAsFixed(1),
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              /// 🔥 Quick Actions Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Text(
                  "Quick Actions",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              /// 🔥 Quick Actions Grid
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: GridView.count(
                  crossAxisCount: screenWidth < 600 ? 3 : 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: screenWidth * 0.04,
                  crossAxisSpacing: screenWidth * 0.04,
                  childAspectRatio: 1,
                  children: [
                    _actionButton(
                      icon: Icons.person,
                      label: "Profile",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CompanyProfile()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.delivery_dining,
                      label: "Delivery Boy",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const CompanyViewDeliveryBoys()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.fastfood,
                      label: "Add Food",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AddFoodItem()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.fastfood_rounded,
                      label: "Food Items",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FoodItemTabBar()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.auto_awesome,
                      label: "Decoration",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DecorationFormPage()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.cake,
                      label: "Cake",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const CakeDecorationFormPage()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.reviews,
                      label: "Reviews",
                      screenWidth: screenWidth,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  RestaurantRating_ReviewPage()),
                        );
                      },
                    ),

                    _actionButton(
                      icon: Icons.logout,
                      label: "Logout",
                      screenWidth: screenWidth,
                      onTap: () {
                        AuthenticationController().logout(context);
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        );
      },
    ),
  );
}




  /// 🔘 Reusable Action Button
 Widget _actionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  required double screenWidth,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(screenWidth * 0.04),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: screenWidth * 0.08,
            color: Colors.red.shade700,
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.tinos(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

}
