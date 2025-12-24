
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
import 'package:agitha/viewfolder/Widgets/ProfileAlert.dart';
import 'package:agitha/viewfolder/Widgets/animateditembar.dart';
import 'package:agitha/viewfolder/Widgets/bottomsheetfood.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
  String logoPath= "assets/projectimages/beefberbgr.png";


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






///ratinf



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
        content: Text('Complete profile for rating'),
      ),
    );
    return;
  }



  final addressProvider = Provider.of<AddressProvider>(context, listen: false);

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
                builder: (_) => const AddAddressPage(), // 👉 YOUR ADDRESS PAGE
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
    id:item["docId"],
    price: double.parse('${item["price"]}'),
    
  ),
 
  onDifferentRestaurant: () {
    // Show your alert here
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Warning"),
        content: Text("You can only add items from the same restaurant."),
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


   








  @override
  Widget build(BuildContext context) {
    







    final colorScheme = Theme.of(context).colorScheme;

     
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
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Image.network(
        widget.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
      ),
    ),

    // 🔹 Back button (top-left)
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          Navigator.pop(context);
        },
        child: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white.withOpacity(0.8),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25,
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
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
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
        height: 120,
      ),
    ),

    // 🔹 Restaurant info
    Positioned(
      bottom: 20,
      left: 20,
      right: 20,
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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white70, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    widget.location, // 📍 Location
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ⭐ Rating badge
          InkWell(
                      onTap: () async {
    // 1️⃣ Check login
    bool loggedIn = await Provider.of<AuthenticationController>(
      context,
      listen: false,
    ).checkLogin(context);

    if (loggedIn) {
      // 2️⃣ Check if profile exists
      final profileService =
          Provider.of<UserRegistrationProvider>(context, listen: false);

      bool exists = await profileService.checkUserProfileExists();

      if (!exists) {
        // Navigate to Profile Form Page
    Navigator.pop(context); // Close bottom sheet safely
     Future.microtask(() {
       Navigator.push(
         context,
         MaterialPageRoute(builder: (_) => const ProfileFormPage()),
       );
});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete profile for rating')),
        );

        return; // ❗ Stop further execution
      }
    

         Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserRestaurantReviewRatingPage(
                retaurantId: widget.restaurantid,
               restaurantname:widget.title ,
               imageUrl: widget.imageUrl,
               rating: widget.rating,

               )),);


    }
  },










            // onTap: () {
            
            // },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children:  [
                  const Icon(Icons.star, color: Colors.orange, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    double.parse(widget.rating).toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.black87,
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
              child: SizedBox(child: Text(
                widget.describtion,
              
                textAlign: TextAlign.center,
                style: GoogleFonts.tinos(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  color:Colors.grey
                              ),
                
                
                )),
            ),





             Row(
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
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: Container(
          height: 1, // thickness of the line
          color: const Color.fromARGB(255, 75, 2, 2),
        ),
      ),
    ),
  ],
),

Padding(
  padding: const EdgeInsets.only(left: 8.0, top: 12.0),
  child: StreamBuilder<List<Map<String, dynamic>>>(
    stream: _controller.specialFoodStream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No food items found"));
      }

      final foodItems = snapshot.data!;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
         
          children: foodItems.map((item) {
            return Align(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () {
                      showModalBottomSheet(
                   context: context,
                   isScrollControlled: true,
                   backgroundColor: Colors.transparent,
                   builder: (context) {
                     return BottomSheetFood(
                       foodname:   item["dishName"],
                       price: item["price"] ,
                       dishid: item["docId"],


                       foodid: item['restaurantId'],
                       rating: item["rating"],
                       foodimg: item["imageUrl"],
                       describtion:   item["describtion"],
                     );
                   },
                 );
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // 🖼️ Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item["imageUrl"] ?? "https://via.placeholder.com/150",
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                                
                      // ⭐ Rating badge
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${item["rating"] ?? "4.5"}",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                                
                      // 🌈 Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            gradient: LinearGradient(
                              colors: [Colors.black54, Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                                
                      // 🏷️ Text: title + price
                      Positioned(
                        bottom: 5,
                        left: 8,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    item["dishName"] ?? "Unnamed",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.tinos(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 6,
                                          color: Colors.black.withOpacity(0.8),
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "₹${item["price"] ?? "0"}",
                                  style: GoogleFonts.tinos(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 6,
                                        color: Colors.black.withOpacity(0.8),
                                        offset: const Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),


 

 ////////////////////////////////////////////////////////////
Positioned(
  bottom: 6,
  right: 6,
  child: Consumer<CartController>(
    builder: (context, cart, _) {
      final cartItems = cart.cart;

      // bool added = cartItems.any(
      //   (x) => x.id == item["docId"], // ✅ BEST check
      // );

       bool added = cartItems.any(
        (x) =>
            x.dishName == item["dishName"] &&
            x.companyName == widget.title,
      );

      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: IconButton(
          onPressed: added
              ? null
              : () {
                  // ✅ PRINT HERE
                  print("FOOD DOC ID: ${item['docId']}");

                  handleAddToCart(
                    context: context,
                    item: item,
                    title: widget.title,
                  );
                },
          icon: added
              ? const Icon(Icons.task_alt, color: Colors.green, size: 23)
              : const Icon(Icons.add, color: Colors.red, size: 18),
        ),
      );
    },
  ),
)













                      
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  ),
),

            



      




      ////////////////////////////////////////////////////////////////////////////////////////////////     
             Padding(
               padding: const EdgeInsets.only(top:10.0,left: 8,bottom: 10.0),
               child: Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 12.0),
                     child: Text(
                       "Recommended",
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
                       padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                       child: Container(
                         height: 1, // thickness of the line
                         color: const Color.fromARGB(255, 75, 2, 2),
                       ),
                     ),
                   ),
                 ],
               ),
             ),

 
  
 
 
   StreamBuilder<List<Map<String, dynamic>>>(
  stream: _controller.normalFoodStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text("No food items found"));
    }

    final foodItems = snapshot.data!;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: foodItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          final item = foodItems[index];

          return Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
            child: InkWell(
              onTap: () {
                  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) {
    return BottomSheetFood(
      foodname:   item["dishName"],
     dishid: item["docId"],

      price: item["price"] ,
      foodid: item['restaurantId'],
      rating: item["rating"],
      foodimg: item["imageUrl"],
      describtion:   item["describtion"],
    );
  },
);
              },

              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Stack for image + rating badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            item['imageUrl'], // ✅ Firestore image URL
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 130, // reduce if you want compact cards
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 80),
                          ),
                        ),
              
                        // ⭐ Rating badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  (item['rating'] ?? '4.5').toString(),
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              
                    // 🏷️ Product title
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        item['dishName'] ?? 'Untitled',
                        style: GoogleFonts.tinos(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              
                    // 💰 Price + Add button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "₹ ${item['price'] ?? '--'}",
                            style: GoogleFonts.tinos(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey[800],
                            ),
                          ),
                          Spacer(),



          Consumer<CartController>(
    builder: (context, cart, _) {
      final cartItems = cart.cart; // ✅ get current user's cart

      bool added = cartItems.any(
        (x) =>
            x.dishName == item["dishName"] &&
            x.companyName == widget.title,
      );

      return  GestureDetector(
  onTap: added
      ? null
      : () {
          handleAddToCart(
            context: context,
            item: item,
            title: widget.title,
          );
        },
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: added ? Colors.grey[100] : colorScheme.primary,
      borderRadius: BorderRadius.circular(6),
    ),
    child: added ? const Text(
       "Added",
      style: TextStyle(
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ):const Text(
       "Add",
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    )
    
    
    
    ,
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
            ),
          );
        },
      ),
    );
  },
),



const SizedBox(height: 100,)










              //food item Container

             
                  ],



                  
        ),
      ),




      
      // your page content here
      
      Align(
        alignment: Alignment.bottomCenter,
        child: BottomCartBar(
          onViewCart: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (_) =>FoodCartPage()));
          },
        ),
      ),
    ],
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isFabVisible ? 1 : 0,
          child: FloatingActionButton.extended(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookEventAndReservationPage()),
              );
            },
            label: Text(
              "Bookings",
              style: GoogleFonts.tinos(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
           
          ),
        ),
      ),
);

      
   




 

            




          

      
      
       


   

          
            
                   


             





            

      
    
    
  }
}
