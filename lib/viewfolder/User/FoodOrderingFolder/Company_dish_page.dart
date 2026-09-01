import 'package:agitha/ControllersFolder/AddressController.dart';
import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ControllersFolder/ViewDishesController.dart';
import 'package:agitha/ModelsFoder/CartModel.dart';
import 'package:agitha/viewfolder/User/BookEventAndReservationPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/AddAddressPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/User_RestaurantRating_ReviewPage.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationsPage.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:agitha/viewfolder/Widgets/ProfileAlert.dart';
import 'package:agitha/viewfolder/Widgets/animateditembar.dart';
import 'package:agitha/viewfolder/Widgets/bottomsheetfood.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyDishPage extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String restaurantid;
  final String rating;
  final String location;
  final String describtion;

  const CompanyDishPage({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.restaurantid,
    required this.location,
    required this.rating,
    required this.describtion,
  });

  @override
  State<CompanyDishPage> createState() => _CompanyDishPageState();
}

class _CompanyDishPageState extends State<CompanyDishPage> {
  String logoPath = "assets/projectimages/beefberbgr.png";

  late ScrollController _scrollController;
  bool _isFabVisible = false;
  final ViewDishesController _controller = ViewDishesController();
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();

    _controller.fetchFoodItemsByIdSpecial(widget.restaurantid);
    _controller.fetchFoodItemsByIdNormal(widget.restaurantid);
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible) {
          setState(() => _isFabVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isFabVisible) {
          setState(() => _isFabVisible = true);
        }
      }
    });
  }

  ///rating

  Future<void> handleAddToCart({
    required BuildContext context,
    required Map item,
    required String title,
  }) async {
    // 1️⃣ Check Login
    bool loggedIn = await Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).checkLogin(context);

    if (!loggedIn) return;

    // 2️⃣ Check Profile Exists
    final profileService =
        Provider.of<UserRegistrationProvider>(context, listen: false);

    bool exists = await profileService.checkUserProfileExists();

    if (!exists) {
      Navigator.pop(context); // Close bottom sheet safely
      Future.microtask(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileFormPage(),
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete profile to add item '),
        ),
      );
      return;
    }

    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

// ✅ First check address availability
    bool hasAddress = await addressProvider.userHasAddress();

    if (!hasAddress) {
      // ❗ User has no address → Show alert & navigate to address page
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("No Address Found"),
          content: const Text(
              "Please add an address before placing orders.\nAdd address now?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AddAddressPage(), // 👉 YOUR ADDRESS PAGE
                  ),
                );
              },
              child: const Text("Add Address"),
            ),
          ],
        ),
      );

      return; // 🚫 Stop from adding to cart
    }

    // 3️⃣ Add Item to Cart
    final cart = Provider.of<CartController>(context, listen: false);

    cart.addToCart(
      CartItem(
        restaurantId: widget.restaurantid,
        companyName: title,
        dishPhoto: item["imageUrl"],
        dishName: item["dishName"],
        id: item["docId"],
        price: double.parse('${item["price"]}'),
      ),
      onDifferentRestaurant: () {
        // Show your alert here
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Warning"),
            content:
                const Text("You can only add items from the same restaurant."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      // Basic validation
      if (url.isEmpty || !Uri.tryParse(url)!.hasAbsolutePath == true) {
        _showErrorPopup(context);
        return;
      }

      final Uri uri = Uri.parse(url);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showErrorPopup(context);
      }
    } on PlatformException catch (e) {
      debugPrint("Launch error: ${e.message}");
      _showErrorPopup(context);
    } catch (e) {
      debugPrint("Unknown error: $e");
      _showErrorPopup(context);
    }
  }

  void _showErrorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Something went wrong"),
        content: const Text(
          "Unable to open the link. Please try again later.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> launchWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    // 🔹 Background image
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(screenWidth * 0.12),
                        bottomRight: Radius.circular(screenWidth * 0.12),
                      ),
                      child: Image.network(widget.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: screenWidth * 0.7,
                          errorBuilder: (context, error, stackTrace) =>
                              NoInternetWidget(
                                width: double.infinity,
                                height: screenWidth * 0.6,
                                iconSize: screenWidth * 0.1,
                                textSize: screenWidth * 0.04,
                              )),
                    ),

                    // 🔹 Back button (top-left)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(screenWidth * 0.1),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: screenWidth * 0.06,
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: screenWidth * 0.06,
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Gradient overlay at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(screenWidth * 0.12),
                            bottomRight: Radius.circular(screenWidth * 0.12),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black54,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        height: screenWidth * 0.30,
                      ),
                    ),

                    // 🔹 Restaurant info
                    Positioned(
                      bottom: screenWidth * 0.06, // Adjust based on screen size
                      left: screenWidth * 0.06,
                      right: screenWidth * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Name & location
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title, // 🏠 Restaurant Name
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.white70,
                                      size: screenWidth * 0.05),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: screenWidth * 0.15,
                                    child: Text(
                                      widget.location
                                          .trim()
                                          .replaceAll(",", "") // removes commas
                                          .split(" ")
                                          .first,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

//button

                          Positioned(
                            bottom: screenWidth * 0.18, // 👈 adjust position
                            right: screenWidth * 0.06,
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 300),
                              offset: _isFabVisible
                                  ? Offset.zero
                                  : const Offset(0, 1),
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _isFabVisible ? 1 : 0,
                                child: SizedBox(
                                  height: screenWidth * 0.13,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.065),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.06),
                                        side: const BorderSide(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              BookEventAndReservationPage(
                                            imageUrl: widget.imageUrl,
                                            restaurantid: widget.restaurantid,
                                            restaurantName: widget.title,
                                            restourentLocation: widget.location,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Bookings",
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

//button

                          // ⭐ Rating badge
                          InkWell(
//

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UserRestaurantReviewRatingPage(
                                          retaurantId: widget.restaurantid,
                                          restaurantname: widget.title,
                                          imageUrl: widget.imageUrl,
                                          rating: widget.rating,
                                        )),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.035,
                                  vertical: screenWidth * 0.015),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.06),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.orange,
                                      size: screenWidth * 0.04),
                                  const SizedBox(width: 4),
                                  Text(
                                    double.parse(widget.rating)
                                        .toStringAsFixed(1),
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
//

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      child: Text(
                    widget.describtion,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.tinos(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                  )),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          "Must Try",
                          style: GoogleFonts.tinos(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 1,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 10),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _controller.specialFoodStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: Text(
                              "No food items found",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      }

                      final foodItems = snapshot.data!;
                      final width = MediaQuery.of(context).size.width;

                      // 🔥 Galaxy Fold safe sizes
                      final bool isFold = width < 330;
                      final double cardSize = isFold ? 120 : 160;
                      final double textSize = isFold ? 12 : 14;
                      final double iconSize = isFold ? 16 : 20;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: foodItems.map((item) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => BottomSheetFood(
                                      foodname: item["dishName"],
                                      price: item["price"],
                                      dishid: item["docId"],
                                      foodid: item['restaurantId'],
                                      rating: item["rating"],
                                      foodimg: item["imageUrl"],
                                      describtion: item["describtion"],
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    /// IMAGE
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.network(
                                        item["imageUrl"] ?? "",
                                        width: cardSize,
                                        height: cardSize,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            NoInternetWidget(
                                          width: cardSize,
                                          height: cardSize,
                                          iconSize: isFold ? 30 : 40,
                                          textSize: isFold ? 10 : 12,
                                        ),
                                      ),
                                    ),

                                    /// RATING
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.star,
                                                color: Colors.amber,
                                                size: iconSize - 2),
                                            const SizedBox(width: 2),
                                            Text(
                                              (item["rating"] ?? 4.5)
                                                  .toStringAsFixed(1),
                                              style: TextStyle(
                                                fontSize: textSize - 2,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    /// GRADIENT
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: cardSize * 0.45,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                              bottom: Radius.circular(14)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black54,
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// NAME + PRICE
                                    Positioned(
                                      bottom: 6,
                                      left: 6,
                                      right: 36,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["dishName"] ?? "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: textSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "₹${item["price"]}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: textSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// ADD BUTTON (SAFE SIZE)
                                    Positioned(
                                      bottom: 6,
                                      right: 6,
                                      child: Consumer<CartController>(
                                        builder: (context, cart, _) {
                                          final added = cart.cart.any(
                                            (x) =>
                                                x.dishName ==
                                                    item["dishName"] &&
                                                x.companyName == widget.title,
                                          );

                                          return CircleAvatar(
                                            radius: isFold ? 16 : 20,
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: iconSize,
                                              onPressed: added
                                                  ? null
                                                  : () => handleAddToCart(
                                                        context: context,
                                                        item: item,
                                                        title: widget.title,
                                                      ),
                                              icon: Icon(
                                                added
                                                    ? Icons.task_alt
                                                    : Icons.add,
                                                color: added
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),

//       ////////////////////////////////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                    thickness: 1,
                    color: Color.fromARGB(255, 75, 2, 2),
                    endIndent: 8,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //normal foodstream

                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _controller.normalFoodStream,
                  builder: (context, snapshot) {
                    final media = MediaQuery.of(context);
                    final width = media.size.width;

                    // 🔥 Galaxy Fold safe breakpoints
                    final bool isFolded = width < 330;
                    final bool isTablet = width >= 600;

                    final int crossAxisCount = isFolded
                        ? 1
                        : isTablet
                            ? 3
                            : 2;

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(
                          child: Text(
                            "No food items found",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    }

                    final foodItems = snapshot.data!;

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: isFolded ? 4 : 8),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: foodItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: isFolded ? 1.15 : 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final item = foodItems[index];

                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => BottomSheetFood(
                                  foodname: item["dishName"],
                                  dishid: item["docId"],
                                  price: item["price"],
                                  foodid: item["restaurantId"],
                                  rating: item["rating"],
                                  foodimg: item["imageUrl"],
                                  describtion: item["describtion"],
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// IMAGE
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(14)),
                                    child: Image.network(
                                      item['imageUrl'],
                                      height: isFolded ? 90 : 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const NoInternetWidget(
                                        width: double.infinity,
                                        height: 90,
                                        iconSize: 35,
                                        textSize: 10,
                                      ),
                                    ),
                                  ),

                                  /// NAME
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 4),
                                    child: Text(
                                      item['dishName'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: isFolded ? 13 : 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  /// PRICE + BUTTON (NO OVERFLOW)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "₹ ${item['price'] ?? '--'}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: isFolded ? 12 : 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Consumer<CartController>(
                                          builder: (context, cart, _) {
                                            final added = cart.cart.any(
                                              (x) =>
                                                  x.dishName ==
                                                      item["dishName"] &&
                                                  x.companyName == widget.title,
                                            );

                                            return SizedBox(
                                              height: 26,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  backgroundColor: added
                                                      ? Colors.grey.shade300
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                ),
                                                onPressed: added
                                                    ? null
                                                    : () => handleAddToCart(
                                                          context: context,
                                                          item: item,
                                                          title: widget.title,
                                                        ),
                                                child: Text(
                                                  added ? "Added" : "Add",
                                                  style: TextStyle(
                                                    fontSize:
                                                        isFolded ? 10 : 11,
                                                    color: added
                                                        ? Colors.red
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
//normal strem ends

                //social media row

                StreamBuilder<Map<String, dynamic>?>(
                  stream: context
                      .read<ViewDishesController>()
                      .fetchCompanyByRestaurantId(widget.restaurantid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox(); // no loading
                    }

                    final data = snapshot.data!;
                    final size = MediaQuery.of(context).size;

                    final double iconSize = size.width * 0.055; // responsive
                    final double padding = size.width * 0.02;

                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Facebook
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.facebook,
                              color: const Color(0xFF1877F2),
                              size: iconSize,
                            ),
                            onPressed: () =>
                                _launchUrl(context, data['facebookUrl']),
                          ),

                          /// Instagram
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.instagram,
                              color: const Color(0xFFE4405F),
                              size: iconSize,
                            ),
                            onPressed: () =>
                                _launchUrl(context, data['instagramUrl']),
                          ),

                          /// WhatsApp
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: const Color(0xFF25D366),
                              size: iconSize,
                            ),
                            onPressed: () {
                              final phone = data['phone']; // ex: 919876543210
                              launchWhatsApp(phone);
                            },
                          ),

                          /// Twitter
                          IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.twitter,
                              color: const Color(0xFF1DA1F2),
                              size: iconSize,
                            ),
                            onPressed: () =>
                                _launchUrl(context, data['twitterUrl']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // your page content here

          Align(
            alignment: Alignment.bottomCenter,
            child: BottomCartBar(
              onViewCart: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => FoodCartPage()));
              },
            ),
          ),
        ],
      ),

// floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
// floatingActionButton: AnimatedSlide(
//   duration: const Duration(milliseconds: 300),
//   offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
//   child: AnimatedOpacity(
//     duration: const Duration(milliseconds: 300),
//     opacity: _isFabVisible ? 1 : 0,
//     child: SizedBox(
//       height: 40, // 👈 very small height
//       child: FloatingActionButton.extended(
//         elevation: 0,
//         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         backgroundColor:Theme.of(context).colorScheme.primary ,
//         foregroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//           side: const BorderSide(
//             color:Colors.white,
//             width: 4,
//           ),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => BookEventAndReservationPage(
//                 imageUrl: widget.imageUrl,
//                 restaurantid: widget.restaurantid,
//                 restaurantName: widget.title,
//                 restourentLocation: widget.location,
//               ),
//             ),
//           );
//         },
//         label: const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//           child: Text(
//             "Bookings",
//             style: TextStyle(
//               fontSize: 12, // 👈 smaller text
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     ),
//   ),
// ),
    );
  }
}
